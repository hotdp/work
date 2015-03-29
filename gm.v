module gm
(
    input CLK,
	 input RSTn,
	 
	 output [3:0]SQ_i,
	 output [4:0]SQ_X,
	 output [6:0]SQ_Y,
	 output [6:0]SQ_Addr,
	 output SQ_isCount,
	 output SQ_isWrite

);
	 
	 /*****************************/
    
	 parameter T1US = 7'd80;

	 /*****************************/
	 
	 reg [6:0]C1;
	 reg [9:0]rTimes;
	 reg isCount;
	 
	 always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		      C1 <= 7'd0;
		  else if( C1 == T1US )
		      C1 <= 7'd0;
		  else if( isCount )
		      C1 <= C1 + 1'b1;
		  else 
		      C1 <= 7'd0;
				
	 /*****************************/
	 
	 reg [9:0]CUS;
	 
	 always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		      CUS <= 10'd0;
		  else if( CUS == rTimes )
		      CUS <= 10'd0;
		  else if( C1 == T1US )
		      CUS <= CUS + 1'b1;
	 
	 /*****************************/
	 
	 reg [3:0]i;
	 reg [6:0]Y;
	 
	 always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		      Y <= 7'd0;
		  else 
		      case( i )
				
				    0 : Y = 7'd0;
					 2 : Y = 7'd16;
					 4 : Y = 7'd32;
					 6 : Y = 7'd48;
					 8 : Y = 7'd64;
					 10: Y = 7'd80;
				
				endcase
				
	 /*****************************/
	 
	 reg [6:0]rAddr; 
	 reg [4:0]X;
	 reg isWrite;
	 
	 always @ ( posedge CLK or negedge RSTn )
	     if( !RSTn )
		      begin
				    i <= 4'd0;
					 rAddr <= 7'd0;
					 X <= 5'd0;
					 isWrite <= 1'b0;
					 isCount <= 1'b0;
					 rTimes <= 10'd100;
				end
		  else
		      case ( i )
					
				    0, 2, 4, 6, 8, 10: 
					 if( X == 16 ) begin rAddr <= 7'd0; X <= 5'd0; isWrite <= 1'b0; i <= i + 1'b1; end
					 else begin rAddr <= Y + X; X = X + 1'b1; isWrite <= 1'b1;end
					 
                1, 3, 5, 7, 9, 11:
					 if( CUS == rTimes ) begin isCount <= 1'b0; i <= i + 1'b1; end
					 else begin rTimes <= 10'd250; isCount <= 1'b1; end
					 
                12:
					 i <= 4'd0;
					 
				endcase
	 
	 /*****************************/
	 
	 assign SQ_i = i;
	 assign SQ_X = X;
	 assign SQ_Y = Y;
	 assign SQ_Addr = rAddr;
	 assign SQ_isCount = isCount;
	 assign SQ_isWrite = isWrite;
	 
	 /******************************/

endmodule
