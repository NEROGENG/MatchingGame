// The width of the screen in pixels
`define PIXEL_WIDTH 640
// The height of the screen in pixels
`define PIXEL_HEIGHT 480

// Used for VGA horizontal and vertical sync
`define HSYNC_FRONT_PORCH 16
`define HSYNC_PULSE_WIDTH 96
`define HSYNC_BACK_PORCH 48
`define VSYNC_FRONT_PORCH 10
`define VSYNC_PULSE_WIDTH 2
`define VSYNC_BACK_PORCH 33

// How many pixels wide/high each block is
`define BLOCK_SIZE 60

// How many blocks wide the game board is
`define BLOCKS_WIDE 4

// How many blocks high the game board is
`define BLOCKS_HIGH 4

// Width of the game board in pixels
`define BOARD_WIDTH (`BLOCKS_WIDE * `BLOCK_SIZE)
// Starting x pixel for the game board
`define BOARD_X (((`PIXEL_WIDTH - `BOARD_WIDTH) / 2))

// Height of the game board in pixels
`define BOARD_HEIGHT (`BLOCKS_HIGH * `BLOCK_SIZE)
// Starting y pixel for the game board
`define BOARD_Y (((`PIXEL_HEIGHT - `BOARD_HEIGHT) / 2))

// The number of bits used to store each block
`define BITS_PER_BLOCK 3

// How many pixels wide/high the cursor is
`define CURSOR_SIZE (`BLOCK_SIZE / 3)

// The type of each block
`define EMPTY_BLOCK 3'b000
`define CYAN_BLOCK 3'b001
`define YELLOW_BLOCK 3'b010
`define PURPLE_BLOCK 3'b011
`define GREEN_BLOCK 3'b100
`define RED_BLOCK 3'b101
`define BLUE_BLOCK 3'b110
`define ORANGE_BLOCK 3'b111

// Color mapping
`define GRAY 8'b10100100
`define CYAN 8'b11110000
`define YELLOW 8'b00111111
`define PURPLE 8'b11000111
`define GREEN 8'b00111000
`define RED 8'b00000111
`define BLUE 8'b11000000
`define ORANGE 8'b00011111
`define BLACK 8'b00000000
