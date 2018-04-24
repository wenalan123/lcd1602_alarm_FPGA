/************************************************************************
 * Author        : Wen Chunyang
 * Email         : 1494640955@qq.com
 * Create time   : 2018-04-23 21:19
 * Last modified : 2018-04-23 21:19
 * Filename      : alarm.v
 * Description   : 
 * *********************************************************************/
module  alarm(
        input                   clk                     ,
        input                   rst_n                   ,
        //key
        input                   key1                    ,
        input                   key2                    ,
        input                   key3                    ,
        //alram
        output  wire  [ 3: 0]   sec_l                   ,
        output  wire  [ 3: 0]   sec_h                   ,
        output  wire  [ 3: 0]   min_l                   ,
        output  wire  [ 3: 0]   min_h                   ,
        output  wire  [ 3: 0]   hour_l                  ,
        output  wire  [ 3: 0]   hour_h                  ,
        output  wire  [ 3: 0]   alarm_min_l             ,
        output  wire  [ 3: 0]   alarm_min_h             ,
        output  wire  [ 3: 0]   alarm_hour_l            ,
        output  wire  [ 3: 0]   alarm_hour_h            ,
        output  reg   [ 2: 0]   adjust 
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
parameter   ADJUST_END  =       6                               ; 
parameter   TIME_1S     =       50_000_000                      ;

reg     [25: 0]                 cnt                             ;
wire                            add_cnt                         ;
wire                            end_cnt                         ;

wire                            add_adjust                      ;
wire                            end_adjust                      ; 

wire                            en                              ; 
wire                            sec_cout                        ;
wire                            min_cout                        ; 
//======================================================================
// ***************      Main    Code    ****************clk_1hz
//======================================================================
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

assign  add_cnt     =       1'd1;       
assign  end_cnt     =       add_cnt && cnt == TIME_1S-1;   



//adjust
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        adjust <= 0;
    end
    else if(add_adjust)begin
        if(end_adjust)
            adjust <= 0;
        else
            adjust <= adjust + 1;
    end
end

assign  add_adjust     =       key1;       
assign  end_adjust     =       add_adjust && adjust == ADJUST_END-1;   


assign  en      =       adjust == 'd0 && end_cnt;


counter60   sec_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //
        .key2                   (key2                   ),
        .key3                   (key3                   ),
        .adjust                 (adjust                 ),
        .mode                   (3'd1                   ),
        .en                     (en                     ),
        .cnt_l                  (sec_l                  ),
        .cnt_h                  (sec_h                  ),
        .cout                   (sec_cout               )
);

counter60   min_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //
        .key2                   (key2                   ),
        .key3                   (key3                   ),
        .adjust                 (adjust                 ),
        .mode                   (3'd2                   ),
        .en                     (sec_cout               ),
        .cnt_l                  (min_l                  ),
        .cnt_h                  (min_h                  ),
        .cout                   (min_cout               )
);

counter24   hour_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //
        .key2                   (key2                   ),
        .key3                   (key3                   ),
        .adjust                 (adjust                 ),
        .mode                   (3'd3                   ),
        .en                     (min_cout               ),
        .cnt_l                  (hour_l                 ),
        .cnt_h                  (hour_h                 )
);

counter60   alarm_min_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //
        .key2                   (key2                   ),
        .key3                   (key3                   ),
        .adjust                 (adjust                 ),
        .mode                   (3'd4                   ),
        .en                     (1'b0                   ),
        .cnt_l                  (alarm_min_l            ),
        .cnt_h                  (alarm_min_h            ),
        .cout                   (                       )
);

counter24   alarm_hour_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //
        .key2                   (key2                   ),
        .key3                   (key3                   ),
        .adjust                 (adjust                 ),
        .mode                   (3'd5                   ),
        .en                     (1'b0                   ),
        .cnt_l                  (alarm_hour_l           ),
        .cnt_h                  (alarm_hour_h           )
);





endmodule
