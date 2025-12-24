typedef enum {
   ADD, 
   SUB, 
   EQ,
   NEQ,
   SHR,
   SHL,
   XOR,
   AND,
   OR,
   NAND,
   MERGE,
   SELECT,
   TILE_MV,
   REG_MV
} opcode_t;

typedef logic [31:0] data_t; 
