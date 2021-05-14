// +private
package winsock

import "core:c"

// @Todo(Judah): Most of these are a holdover from previous bindings I did for
// winsock2. They should most likely be removed in favor of the types in sys/windows/...

u_char   :: c.uchar;
u_short  :: c.ushort;
u_int    :: c.uint;
u_long   :: c.ulong;
WORD     :: c.ushort;
DWORD    :: distinct u32;
BYTE     :: distinct c.uchar;
UINT_PTR :: SOCKET;

LPVOID :: rawptr;
HANDLE :: distinct LPVOID;
HWND   :: distinct HANDLE;

CHAR    :: c.char;
LPSTR   :: ^CHAR;
wchar_t :: c.wchar_t;
WCHAR   :: wchar_t;
WSTR    :: ^WCHAR;
LPCWSTR :: WSTR;
WPARAM  :: distinct u64;

GUID :: struct {
    Data1: DWORD,
    Data2: WORD,
    Data3: WORD,
    Data4: [8]BYTE,
}

OVERLAPPED :: struct {
    Internal     : ^c.ulong,
    InternalHigh : ^c.ulong,
    Offset       : DWORD,
    OffsetHigh   : DWORD,
    hEvent       : HANDLE,
}
