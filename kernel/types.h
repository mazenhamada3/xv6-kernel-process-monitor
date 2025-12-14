typedef unsigned int   uint;
typedef unsigned short ushort;
typedef unsigned char  uchar;

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int  uint32;
typedef unsigned long uint64;

typedef uint64 pde_t;

// Structure to hold date and time components
struct rtcdate {
  uint year;
  uint month;
  uint day;
  uint hour;
  uint minute;
  uint second;
};
