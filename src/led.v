/************************************************************************
 * Author        : Wen Chunyang
 * Email         : 1494640955@qq.com
 * Create time   : 2018-04-24 11:47
 * Last modified : 2018-04-24 11:47
 * Filename      : led.v
 * Description   : 
 * *********************************************************************/
module  led(
        input                   clk                     ,
        input                   rst_n                   ,
        //alarm
        input         [ 3: 0]   alarm_min_l             ,
        input         [ 3: 0]   alarm_min_h             ,
        input         [ 3: 0]   alarm_hour_l            ,
        input         [ 3: 0]   alarm_hour_h            ,
        input         [ 3: 0]   min_l                   ,
        input         [ 3: 0]   min_h                   ,
        input         [ 3: 0]   hour_l                  ,
        input         [ 3: 0]   hour_h                  ,
        //led               
        output  reg             led 
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
parameter   TIME_0_1S   =       5_000_000                       ;
reg     [22: 0]                 cnt                             ;
wire                            add_cnt                         ;
wire                            end_cnt                         ; 



//======================================================================
// ***************      Main    Code    ****************
//======================================================================
assign  alarm       =       (alarm_hour_h == hour_h) && (alarm_hour_l == hour_l) && (alarm_min_h == min_h) && (alarm_min_l == min_l);

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
end

assign  add_cnt     =       alarm;       
assign  end_cnt     =       add_cnt && cnt == TIME_0_1S-1;   

//led
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        led <=  1'b0;
    end
    else if(alarm && end_cnt)begin
        led <=  ~led;
    end
    else if(alarm)
        led <=  led;
    else
        led <=  1'b0;
end





endmodule
