/************************************************************************
 * Author        : Wen Chunyang
 * Email         : 1494640955@qq.com
 * Create time   : 2018-04-23 10:25
 * Last modified : 2018-04-23 10:25
 * Filename      : debounce.v
 * Description   : 
 * *********************************************************************/
module  debounce(
        input                   clk                     ,
        input                   rst_n                   ,
        //key
        input                   key_in                  ,
        output  wire            key_out 
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
parameter   TIME_20MS           =        1_000_000              ;//clk=50Mhz 20ms 
parameter   TIME_0_5S           =        25_000_000             ;//0.5s 
reg     [24: 0]                 cnt                             ;
wire                            add_cnt                         ;
wire                            end_cnt                         ;

reg     [ 1: 0]                 key_r                           ; 

//======================================================================
// ***************      Main    Code    ****************
//======================================================================
//key_r  打两拍，这里是异步处理
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        key_r   <=      'd0;
    end
    else begin
        key_r   <=      {key_r[0],key_in};
    end
end

//cnt
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt <= 0;
    end
    else if(add_cnt)begin
        if(end_cnt)
            cnt <= 0;  
        else
            cnt <= cnt + 1;
    end
    else begin
        cnt <=  0;
    end
end

assign  add_cnt     =       key_r[1] == 1'b0;       
assign  end_cnt     =       add_cnt && cnt == TIME_0_5S-1;   

assign  key_out     =       add_cnt && cnt == TIME_20MS-1;//连续按有效,并且支持快速按





endmodule
