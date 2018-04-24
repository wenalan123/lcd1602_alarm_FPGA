/************************************************************************
 * Author        : Wen Chunyang
 * Email         : 1494640955@qq.com
 * Create time   : 2018-04-23 18:32
 * Last modified : 2018-04-23 18:32
 * Filename      : top.v
 * Description   : 
 * *********************************************************************/
module  top(
        input                   clk                     ,
        input                   s_rst_n                 ,
        //key
        input                   key1                    ,//adjust
        input                   key2                    ,//add
        input                   key3                    ,//sub
        //led
        output  wire            led                     ,//alarm时，ledg0闪烁
        //lcd
        output  wire            rs                      ,
        output  wire            rw                      ,
        output  wire            en                      ,
        output  wire            on                      ,
        output  wire  [ 7: 0]   data                    
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
wire                            key1_out                        ;
wire                            key2_out                        ; 
wire                            key3_out                        ; 

wire    [ 3: 0]                 sec_l                           ; 
wire    [ 3: 0]                 sec_h                           ;
wire    [ 3: 0]                 min_l                           ;
wire    [ 3: 0]                 min_h                           ;
wire    [ 3: 0]                 hour_l                          ;
wire    [ 3: 0]                 hour_h                          ;

wire    [ 3: 0]                 alarm_min_l                     ;
wire    [ 3: 0]                 alarm_min_h                     ;
wire    [ 3: 0]                 alarm_hour_l                    ;
wire    [ 3: 0]                 alarm_hour_h                    ;



wire    [ 2: 0]                 adjust                          ; 

reg     [ 1: 0]                 rst_r                           ; 
wire                            rst_n                           ; 


//======================================================================
// ***************      Main    Code    ****************
//======================================================================
//rst_r  异步复位，同步释放
always  @(posedge clk or negedge s_rst_n)begin
    if(s_rst_n==1'b0)begin
        rst_r   <=  'd0;
    end
    else begin
        rst_r   <=  {rst_r[0],1'b1};
    end
end

assign  rst_n   =       rst_r[1];

lcd lcd_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //alarm
        .sec_l                  (sec_l                  ),
        .sec_h                  (sec_h                  ),
        .min_l                  (min_l                  ),
        .min_h                  (min_h                  ),
        .hour_l                 (hour_l                 ),
        .hour_h                 (hour_h                 ),
        .alarm_min_l            (alarm_min_l            ),
        .alarm_min_h            (alarm_min_h            ),
        .alarm_hour_l           (alarm_hour_l           ),
        .alarm_hour_h           (alarm_hour_h           ),
        .adjust                 (adjust                 ),
        //lcd
        .rs                     (rs                     ),
        .rw                     (rw                     ),
        .en                     (en                     ),
        .on                     (on                     ),
        .data                   (data                   )
);

alarm   alarm_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //key
        .key1                   (key1_out               ),
        .key2                   (key2_out               ),
        .key3                   (key3_out               ),
        //alram
        .sec_l                  (sec_l                  ),
        .sec_h                  (sec_h                  ),
        .min_l                  (min_l                  ),
        .min_h                  (min_h                  ),
        .hour_l                 (hour_l                 ),
        .hour_h                 (hour_h                 ),
        .alarm_min_l            (alarm_min_l            ),
        .alarm_min_h            (alarm_min_h            ),
        .alarm_hour_l           (alarm_hour_l           ),
        .alarm_hour_h           (alarm_hour_h           ),
        .adjust                 (adjust                 )
);

led led_inst(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //alarm
        .alarm_min_l            (alarm_min_l            ),
        .alarm_min_h            (alarm_min_h            ),
        .alarm_hour_l           (alarm_hour_l           ),
        .alarm_hour_h           (alarm_hour_h           ),
        .min_l                  (min_l                  ),
        .min_h                  (min_h                  ),
        .hour_l                 (hour_l                 ),
        .hour_h                 (hour_h                 ),
        //led               
        .led                    (led                    )
);

//支持快速按，连续按，快速连按
debounce    debounce_inst1(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //key
        .key_in                 (key1                   ),
        .key_out                (key1_out               )
);

debounce    debounce_inst2(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //key
        .key_in                 (key2                   ),
        .key_out                (key2_out               )
);

debounce    debounce_inst3(
        .clk                    (clk                    ),
        .rst_n                  (rst_n                  ),
        //key
        .key_in                 (key3                   ),
        .key_out                (key3_out               )
);

endmodule
