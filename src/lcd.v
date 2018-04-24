/************************************************************************
 * Author        : Wen Chunyang
 * Email         : 1494640955@qq.com
 * Create time   : 2018-04-22 19:29
 * Last modified : 2018-04-22 19:29
 * Filename      : display.v
 * Description   : 
 * *********************************************************************/
module  lcd(
        input                   clk                     ,
        input                   rst_n                   ,
        //alarm
        input         [ 3: 0]   sec_l                   ,
        input         [ 3: 0]   sec_h                   ,
        input         [ 3: 0]   min_l                   ,
        input         [ 3: 0]   min_h                   ,
        input         [ 3: 0]   hour_l                  ,
        input         [ 3: 0]   hour_h                  ,
        input         [ 3: 0]   alarm_min_l             ,
        input         [ 3: 0]   alarm_min_h             ,
        input         [ 3: 0]   alarm_hour_l            ,
        input         [ 3: 0]   alarm_hour_h            ,
        input         [ 2: 0]   adjust                  ,
        //lcd
        output  reg             rs                      ,
        output  wire            rw                      ,
        output  wire            en                      ,
        output  wire            on                      ,
        output  reg   [ 7: 0]   data                    
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
parameter   TIME_15MS   =       750_000                         ; 
parameter   TIME_0_2S   =       10_000_000                      ; 
parameter   TIME_500HZ  =       50_000                          ; 
parameter   IDLE        =       6'd0                            ; 
parameter   INIT        =       6'd1                            ;
parameter   S0          =       6'd2                            ;
parameter   S1          =       6'd3                            ;
parameter   S2          =       6'd4                            ; 
parameter   S3          =       6'd5                            ;
parameter   ROW1        =       6'd6                            ; 
parameter   ONE0        =       6'd7                            ; 
parameter   ONE1        =       6'd8                            ; 
parameter   ONE2        =       6'd9                            ; 
parameter   ONE3        =       6'd10                           ; 
parameter   ONE4        =       6'd11                           ; 
parameter   ONE5        =       6'd12                           ; 
parameter   ONE6        =       6'd13                           ; 
parameter   ONE7        =       6'd14                           ; 
parameter   ONE8        =       6'd15                           ; 
parameter   ONE9        =       6'd16                           ; 
parameter   ONE10       =       6'd17                           ; 
parameter   ONE11       =       6'd18                           ; 
parameter   ONE12       =       6'd19                           ; 
parameter   ONE13       =       6'd20                           ; 
parameter   ONE14       =       6'd21                           ; 
parameter   ONE15       =       6'd22                           ; 
parameter   ROW2        =       6'd23                           ; 
parameter   TWO0        =       6'd24                           ; 
parameter   TWO1        =       6'd25                           ; 
parameter   TWO2        =       6'd26                           ; 
parameter   TWO3        =       6'd27                           ; 
parameter   TWO4        =       6'd28                           ; 
parameter   TWO5        =       6'd29                           ; 
parameter   TWO6        =       6'd30                           ; 
parameter   TWO7        =       6'd31                           ; 
parameter   TWO8        =       6'd32                           ; 
parameter   TWO9        =       6'd33                           ; 
parameter   TWO10       =       6'd34                           ; 
parameter   TWO11       =       6'd35                           ; 
parameter   TWO12       =       6'd36                           ; 
parameter   TWO13       =       6'd37                           ; 
parameter   TWO14       =       6'd38                           ; 
parameter   TWO15       =       6'd39                           ; 
reg     [ 5: 0]                 status_c                        ;
reg     [ 5: 0]                 status_n                        ; 

wire    [ 7: 0]                 one_0                           ; 
wire    [ 7: 0]                 one_1                           ; 
wire    [ 7: 0]                 one_2                           ; 
wire    [ 7: 0]                 one_3                           ; 
wire    [ 7: 0]                 one_4                           ; 
wire    [ 7: 0]                 one_5                           ; 
reg     [ 7: 0]                 one_6                           ; 
reg     [ 7: 0]                 one_7                           ; 
wire    [ 7: 0]                 one_8                           ; 
reg     [ 7: 0]                 one_9                           ; 
reg     [ 7: 0]                 one_10                          ; 
wire    [ 7: 0]                 one_11                          ; 
wire    [ 7: 0]                 one_12                          ; 
wire    [ 7: 0]                 one_13                          ; 
wire    [ 7: 0]                 one_14                          ; 
wire    [ 7: 0]                 one_15                          ;

wire    [ 7: 0]                 two_0                           ; 
wire    [ 7: 0]                 two_1                           ; 
wire    [ 7: 0]                 two_2                           ; 
wire    [ 7: 0]                 two_3                           ; 
wire    [ 7: 0]                 two_4                           ; 
wire    [ 7: 0]                 two_5                           ; 
reg     [ 7: 0]                 two_6                           ; 
reg     [ 7: 0]                 two_7                           ; 
wire    [ 7: 0]                 two_8                           ; 
reg     [ 7: 0]                 two_9                           ; 
reg     [ 7: 0]                 two_10                          ; 
wire    [ 7: 0]                 two_11                          ; 
reg     [ 7: 0]                 two_12                          ; 
reg     [ 7: 0]                 two_13                          ; 
wire    [ 7: 0]                 two_14                          ; 
wire    [ 7: 0]                 two_15                          ; 

reg                             scan_flag                       ; 
reg     [23: 0]                 cnt1                            ;
wire                            add_cnt1                        ;
wire                            end_cnt1                        ;

reg     [15: 0]                 cnt                             ;
wire                            add_cnt                         ;
wire                            end_cnt                         ;
reg                             lcd_clk                         ; 

reg     [19: 0]                 cnt2                            ;
wire                            add_cnt2                        ;
wire                            end_cnt2                        ;
reg                             flag                            ; 

//======================================================================
// ***************      Main    Code    ****************
//======================================================================
assign  on          =       1'b1;//lcd on
assign  rw          =       1'b0;//只写不读
assign  en          =       lcd_clk;

assign  one_0       =       "A";
assign  one_1       =       "l";
assign  one_2       =       "a";
assign  one_3       =       "r";
assign  one_4       =       "m";
assign  one_5       =       ":";
assign  one_8       =       "-";
assign  one_11      =       " ";
assign  one_12      =       " ";
assign  one_13      =       " ";
assign  one_14      =       " ";
assign  one_15      =       " ";

assign  two_0       =       "C";
assign  two_1       =       "l";
assign  two_2       =       "o";
assign  two_3       =       "c";
assign  two_4       =       "k";
assign  two_5       =       ":";
assign  two_8       =       "-";
assign  two_11      =       "-";
assign  two_14      =       " ";
assign  two_15      =       " ";

//cnt1
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt1 <= 0;
    end
    else if(add_cnt1)begin
        if(end_cnt1)
            cnt1 <= 0;
        else
            cnt1 <= cnt1 + 1;
    end
end

assign  add_cnt1        =       1'b1;       
assign  end_cnt1        =       add_cnt1 && cnt1 == TIME_0_2S-1;

//scan_flag
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        scan_flag   <=  1'b0;
    end
    else if(end_cnt1)begin
        scan_flag   <=  ~scan_flag;
    end
end

//two_12,two_13
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        two_12  <=  8'h30;
        two_13  <=  8'h30;
    end
    else if(adjust == 'd1 && scan_flag)begin
        two_12  <=  8'h20;//空白,adjust时会有跳动的效果
        two_13  <=  8'h20;
    end
    else begin
        two_12  <=  sec_h + 8'h30;
        two_13  <=  sec_l + 8'h30;
    end
end

//two_9,two_10
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        two_9   <=  8'h30;
        two_10  <=  8'h30;
    end
    else if(adjust == 'd2 && scan_flag)begin
        two_9   <=  8'h20;//空白,adjust时会有跳动的效果
        two_10  <=  8'h20;
    end
    else begin
        two_9   <=  min_h + 8'h30;
        two_10  <=  min_l + 8'h30;
    end
end

//two_6,two_7
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        two_6   <=  8'h30;
        two_7   <=  8'h30;
    end
    else if(adjust == 'd3 && scan_flag)begin
        two_6   <=  8'h20;//空白,adjust时会有跳动的效果
        two_7   <=  8'h20;
    end
    else begin
        two_6   <=  hour_h + 8'h30;
        two_7   <=  hour_l + 8'h30;
    end
end

//one_9,one_10
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        one_9   <=      8'h30;
        one_10  <=      8'h30;
    end
    else if(adjust == 'd4 && scan_flag)begin
        one_9   <=      8'h20;
        one_10  <=      8'h20;
    end
    else begin
        one_9   <=      alarm_min_h + 8'h30;
        one_10  <=      alarm_min_l + 8'h30;
    end
end

//one_6,one_7
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        one_6   <=      8'h30;
        one_7   <=      8'h30;
    end
    else if(adjust == 'd5 && scan_flag)begin
        one_6   <=      8'h20;
        one_7   <=      8'h20;
    end
    else begin
        one_6   <=      alarm_hour_h + 8'h30;
        one_7   <=      alarm_hour_l + 8'h30;
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
end

assign  add_cnt     =       1'b1;       
assign  end_cnt     =       add_cnt && cnt == TIME_500HZ-1;   

//lcd_clk 
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        lcd_clk     <=      1'b0;
    end
    else if(end_cnt)begin
        lcd_clk     <=      ~lcd_clk;
    end
end

//cnt2
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt2 <= 0;
    end
    else if(add_cnt2)begin
        if(end_cnt2)
            cnt2 <= 0;
        else
            cnt2 <= cnt2 + 1;
    end
end

assign  add_cnt2        =       flag == 1'b0;       
assign  end_cnt2        =       add_cnt2 && cnt2 == TIME_15MS-1;

//flag
always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        flag    <=  1'b0;
    end
    else if(end_cnt2)begin
        flag    <=  1'b1;
    end
end

//status_c
always@(posedge lcd_clk or negedge rst_n)begin
    if(!rst_n)begin
        status_c <= IDLE;
    end
    else begin
        status_c <= status_n;
    end
end

//status_n
always@(*)begin
    case(status_c)
        //----------------初始化------------------
        IDLE:begin
            rs          <=      1'b0;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      8'h38;
            if(flag)                   //上电后等待15ms,电平稳定了再下一步
                status_n    <=      INIT; 
            else
                status_n    <=      status_c;
        end
        INIT:begin
            rs          <=      1'b0;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      8'h38;
            status_n    <=      S0; 
        end
        S0:begin
            rs          <=      1'b0;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      8'h08;
            status_n    <=      S1; 
        end
        S1:begin
            rs          <=      1'b0;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      8'h01;
            status_n    <=      S2; 
        end
        S2:begin
            rs          <=      1'b0;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      8'h06;
            status_n    <=      S3; 
        end
        S3:begin
            rs          <=      1'b0;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      8'h0c;
            status_n    <=      ROW1; 
        end
        //-----------第一行DDRAM首地址------------
        ROW1:begin
            rs          <=      1'b0;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      8'h80;
            status_n    <=      ONE0; 
        end
        //------------第一行数据-----------------
        ONE0:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      one_0;
            status_n    <=      ONE1; 
        end
        ONE1:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      one_1;
            status_n    <=      ONE2; 
        end
        ONE2:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      one_2;
            status_n    <=      ONE3; 
        end
        ONE3:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      one_3;
            status_n    <=      ONE4; 
        end
        ONE4:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      one_4;
            status_n    <=      ONE5; 
        end
        ONE5:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      one_5;
            status_n    <=      ONE6; 
        end
        ONE6:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      one_6;
            status_n    <=      ONE7; 
        end
        ONE7:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      one_7;
            status_n    <=      ONE8; 
        end
        ONE8:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      one_8;
            status_n    <=      ONE9; 
        end
        ONE9:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      one_9;
            status_n    <=      ONE10; 
        end
        ONE10:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      one_10;
            status_n    <=      ONE11; 
        end
        ONE11:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      one_11;
            status_n    <=      ONE12; 
        end
        ONE12:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      one_12;
            status_n    <=      ONE13; 
        end
        ONE13:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      one_13;
            status_n    <=      ONE14; 
        end
        ONE14:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      one_14;
            status_n    <=      ONE15; 
        end
        ONE15:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      one_15;
            status_n    <=      ROW2; 
        end
        //---------------第二行首地址---------------
        ROW2:begin
            rs          <=      1'b0;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      8'hc0;
            status_n    <=      TWO0; 
        end
        //-------------第二行数据-------------------
        TWO0:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      two_0;
            status_n    <=      TWO1; 
        end
        TWO1:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      two_1;
            status_n    <=      TWO2; 
        end
        TWO2:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      two_2;
            status_n    <=      TWO3; 
        end
        TWO3:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      two_3;
            status_n    <=      TWO4; 
        end
        TWO4:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      two_4;
            status_n    <=      TWO5; 
        end
        TWO5:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      two_5;
            status_n    <=      TWO6; 
        end
        TWO6:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      two_6;
            status_n    <=      TWO7; 
        end
        TWO7:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      two_7;
            status_n    <=      TWO8; 
        end
        TWO8:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      two_8;
            status_n    <=      TWO9; 
        end
        TWO9:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      two_9;
            status_n    <=      TWO10; 
        end
        TWO10:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      two_10;
            status_n    <=      TWO11; 
        end
        TWO11:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      two_11;
            status_n    <=      TWO12; 
        end
        TWO12:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      two_12;
            status_n    <=      TWO13; 
        end
        TWO13:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      two_13;
            status_n    <=      TWO14; 
        end
        TWO14:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      two_14;
            status_n    <=      TWO15; 
        end
        TWO15:begin
            rs          <=      1'b1;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      two_15;
            status_n    <=      ROW1; 
        end
        default:begin
            rs          <=      1'b0;  //rs高是数据寄存器，rs低是指令寄存器
            data        <=      8'h00;
            status_n    <=      IDLE; 
        end
    endcase
end








endmodule
