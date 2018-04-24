/************************************************************************
 * Author        : Wen Chunyang
 * Email         : 1494640955@qq.com
 * Create time   : 2018-04-19 12:55
 * Last modified : 2018-04-19 12:55
 * Filename      : counter24.v
 * Description   : 
 * *********************************************************************/
module  counter24(
        input                   clk                     ,
        input                   rst_n                   ,
        //
        input                   key2                    ,
        input                   key3                    ,
        input         [ 2: 0]   adjust                  ,
        input         [ 2: 0]   mode                    ,
        //
        input                   en                      ,
        output  wire  [ 3: 0]   cnt_l                   ,
        output  wire  [ 3: 0]   cnt_h                   
);
//=====================================================================\
// ********** Define Parameter and Internal Signals *************
//=====================================================================/
reg     [ 3: 0]                 cnt0                            ;
wire                            add_cnt0                        ;
wire                            end_cnt0                        ;

reg     [ 3: 0]                 cnt1                            ;
wire                            add_cnt1                        ;
wire                            end_cnt1                        ;

//======================================================================
// ***************      Main    Code    ****************
//======================================================================
//cnt0
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        cnt0 <= 0;
    end
    else if(adjust == mode)begin
        if(key2)begin
            if((cnt0 == 10-1 && cnt1 < 2) || (cnt0 == 4-1 && cnt1 == 2))
                cnt0    <=  'd0;
            else
                cnt0    <=  cnt0 + 1'b1;
        end
        else if(key3)begin
            if(cnt0 == 'd0 && cnt1 == 'd0)
                cnt0    <=  'd3;
            else if(cnt0 == 'd0 && cnt1 != 'd0)
                cnt0    <=  'd9;
            else
                cnt0    <=  cnt0 - 1'b1;  
        end
    end
    else if(add_cnt0)begin
        if(end_cnt0)
            cnt0 <= 0;
        else
            cnt0 <= cnt0 + 1;
    end
end

assign  add_cnt0        =       en;
assign  end_cnt0        =       (add_cnt0 && cnt0 == 10-1 && cnt1 < 2) || (add_cnt0 && cnt0 == 4-1 && cnt1 == 2);

//cnt1
always @(posedge clk or negedge rst_n)begin 
    if(!rst_n)begin
        cnt1 <= 0;
    end
    else if(adjust == mode)begin
        if(key2 && cnt0 == 'd9 && cnt1 < 2)//cnt1 加一条件
            cnt1    <=  cnt1 + 1'b1;
        else if(key2 && cnt0 == 'd3 && cnt1 == 2)
            cnt1    <=  'd0;
        else if(key3 && cnt0 == 'd0)begin//cnt1 减一条件
            if(cnt1 == 'd0)
                cnt1    <=  'd2;
            else    
                cnt1    <=  cnt1 - 1'b1;
        end
    end
    else if(add_cnt1)begin
        if(end_cnt1)
            cnt1 <= 0;
        else
            cnt1 <= cnt1 + 1;
    end
end

assign  add_cnt1        =       end_cnt0;
assign  end_cnt1        =       add_cnt1 && cnt1 == 3-1;

assign  cnt_l           =       cnt0;
assign  cnt_h           =       cnt1;




endmodule
