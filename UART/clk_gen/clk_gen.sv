`timescale 1ns / 1ps

module clk_gen(
    input clk, rst,
    input [16:0] baud_rate_val,
    output reg tx_clk, rx_clk
);

    // Assuming F_clk = 50MHz
    // For 9600 baud:
    // TX_CLK frequency = 9600 Hz
    // Period TX_CLK = 1/9600 s
    // Number of clk cycles per TX_CLK period = 50e6 / 9600 = 5208.33 cycles.
    // We want tx_clk to toggle when tx_count reaches tx_max_count.
    // tx_clk period will be 2 * (tx_max_count + 1) cycles.
    // So, (tx_max_count + 1) = 50e6 / (2 * 9600) = 50e6 / 19200 = 2604.16
    // So, tx_max_count = 2604 - 1 = 2603

    // RX_CLK frequency = 16 * 9600 = 153600 Hz
    // Period RX_CLK = 1/153600 s
    // Number of clk cycles per RX_CLK period = 50e6 / 153600 = 325.52 cycles.
    // We want rx_clk to toggle when rx_count reaches rx_max_count.
    // rx_clk period will be 2 * (rx_max_count + 1) cycles.
    // So, (rx_max_count + 1) = 50e6 / (2 * 153600) = 50e6 / 307200 = 162.76
    // So, rx_max_count = 163 - 1 = 162

    reg [13:0] tx_max_count;
    reg [10:0] rx_max_count;

    reg [13:0] tx_count;
    reg [10:0] rx_count;

    // This block determines the max count values based on baud_rate_val
    // This should be combinational or registered once.
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_max_count <= 0;
            rx_max_count <= 0;
        end else begin
            case(baud_rate_val)
                4800: begin
                    tx_max_count <= 14'd5207; // 50e6 / (2 * 4800) - 1 = 5208 - 1
                    rx_max_count <= 11'd325;  // 50e6 / (2 * 16 * 4800) - 1 = 325.5 - 1 = 324
                end
                9600: begin
                    tx_max_count <= 14'd2603; // 50e6 / (2 * 9600) - 1 = 2604 - 1
                    rx_max_count <= 11'd162;  // 50e6 / (2 * 16 * 9600) - 1 = 162.76 - 1 = 161
                end
                14400: begin
                    tx_max_count <= 14'd1735; // 50e6 / (2 * 14400) - 1 = 1736 - 1
                    rx_max_count <= 11'd108;  // 50e6 / (2 * 16 * 14400) - 1 = 108.5 - 1 = 107
                end
                19200: begin
                    tx_max_count <= 14'd1301; // 50e6 / (2 * 19200) - 1 = 1302 - 1
                    rx_max_count <= 11'd81;   // 50e6 / (2 * 16 * 19200) - 1 = 81.38 - 1 = 80
                end
                38400: begin
                    tx_max_count <= 14'd650;  // 50e6 / (2 * 38400) - 1 = 651 - 1
                    rx_max_count <= 11'd40;   // 50e6 / (2 * 16 * 38400) - 1 = 40.69 - 1 = 39
                end
                57600: begin
                    tx_max_count <= 14'd433;  // 50e6 / (2 * 57600) - 1 = 434 - 1
                    rx_max_count <= 11'd27;   // 50e6 / (2 * 16 * 57600) - 1 = 27.12 - 1 = 26
                end
                115200: begin
                    tx_max_count <= 14'd216; // 50e6 / (2 * 115200) - 1 = 217 - 1
                    rx_max_count <= 11'd13;  // 50e6 / (2 * 16 * 115200) - 1 = 13.56 - 1 = 12
                end
                128000: begin
                    tx_max_count <= 14'd194; // 50e6 / (2 * 128000) - 1 = 195 - 1
                    rx_max_count <= 11'd12;  // 50e6 / (2 * 16 * 128000) - 1 = 12.2 - 1 = 11
                end
                default: begin
                    tx_max_count <= 14'd2603; // Default to 9600 baud
                    rx_max_count <= 11'd162;
                end
            endcase
        end
    end

    // Clock generation for tx_clk
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_count <= 0;
            tx_clk <= 0;
        end else begin
            if (tx_count == tx_max_count) begin
                tx_clk <= ~tx_clk;
                tx_count <= 0;
            end else begin
                tx_count <= tx_count + 1;
            end
        end
    end

    // Clock generation for rx_clk
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rx_count <= 0;
            rx_clk <= 0;
        end else begin
            if (rx_count == rx_max_count) begin
                rx_clk <= ~rx_clk;
                rx_count <= 0;
            end else begin
                rx_count <= rx_count + 1;
            end
        end
    end

endmodule