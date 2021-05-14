package winsock

import "core:c"

foreign import winsock2 "system:Ws2_32.lib"

/*
    Todo:
        - Properly convert _IO* macros and set FIO/SIO constants using them
        - Properly convert _IN_CLASS* macros
        - Double check all bitwise negation (~) constants since they require a cast
        - Double check all #raw_unions to make sure they work how they're supposed to
        - Double check all enums to make sure they work how they're supposed to
        - Possibly(?) split winsock1 and winsock2 into separate modules like they are in C
*/

// === Winsock ===

// === Private utilities, types, macros, etc. ===


// Converted macros
// _IO      :: proc(x: i32, y: i32)            -> i32 { return (IOC_VOID | (x << 8) | y);                                                   }
// _IOR     :: proc(x: i32, y: i32, t: typeid) -> i32 { return (IOC_OUT  | ((cast(c.long)size_of(t) & IOCPARM_MASK) << 16 | (x << 8) | y)); }
// _IOW     :: proc(x: i32, y: i32, t: typeid) -> i32 { return (IOC_IN   | ((cast(c.long)size_of(t) & IOCPARM_MASK) << 16 | (x << 8) | y)); }

// === Public API ===
WINSOCK_VERSION : WORD : 2 | (2 << 8);

// Defines
// Workaround for:
// #define invalid_socket  (socket)(~0)
// #define socket_error            (-1)
SOCKET :: distinct uintptr;

INVALID_SOCKET :: ~SOCKET(0);
SOCKET_ERROR   :: -1;

SOCKADDR    :: sockaddr;
SOCKADDR_IN :: sockaddr_in;
LINGER      :: linger;
FD_SET      :: fd_set;
HOSTENT     :: hostent;
SERVENT     :: servent;
PROTOENT    :: protoent;
TIMEVAL     :: timeval;

FD_SETSIZE :: 64;

IOCPARM_MASK :: 0x7f;
IOC_VOID     :: 0x20000000;
IOC_OUT      :: 0x40000000;
IOC_IN       :: 0x80000000;
IOC_INOUT    :: IOC_IN | IOC_OUT;

// FIONREAD := _IOR('f', 127, u_long);
// FIONBIO  := _IOW('f', 126, u_long);
// FIOASYNC := _IOW('f', 125, u_long);
// SIOCSHIWAT := _IOW('s', 0, u_long);
// SIOCGHIWAT := _IOR('s', 1, u_long);
// SIOCSLOWAT := _IOW('s', 2, u_long);
// SIOCGLOWAT := _IOR('s', 3, u_long);
// SIOCATMARK := _IOR('s', 7, u_long);

IPPROTO_IP   :: 0;
IPPROTO_ICMP :: 1;
IPPROTO_IGMP :: 2;
IPPROTO_GGP  :: 3;
IPPROTO_TCP  :: 6;
IPPROTO_PUP  :: 12;
IPPROTO_UDP  :: 17;
IPPROTO_IDP  :: 22;
IPPROTO_ND   :: 77;
IPPROTO_RAW  :: 255;
IPPROTO_MAX  :: 256;

IPPORT_ECHO       :: 7;
IPPORT_DISCARD    :: 9;
IPPORT_SYSTAT     :: 11;
IPPORT_DAYTIME    :: 13;
IPPORT_NETSTAT    :: 15;
IPPORT_FTP        :: 21;
IPPORT_TELNET     :: 23;
IPPORT_SMTP       :: 25;
IPPORT_TIMESERVER :: 37;
IPPORT_NAMESERVER :: 42;
IPPORT_WHOIS      :: 43;
IPPORT_MTP        :: 57;

IPPORT_TFTP    :: 69;
IPPORT_RJE     :: 77;
IPPORT_FINGER  :: 79;
IPPORT_TTYLINK :: 87;
IPPORT_SUPDUP  :: 95;

IPPORT_EXECSERVER  :: 512;
IPPORT_LOGINSERVER :: 513;
IPPORT_CMDSERVER   :: 514;
IPPORT_EFSSERVER   :: 520;

IPPORT_BIFFUDP     :: 512;
IPPORT_WHOSERVER   :: 513;
IPPORT_ROUTESERVER :: 520;

IPPORT_RESERVED :: 1024;

IMPLINK_IP        :: 155;
IMPLINK_LOWEXPER  :: 156;
IMPLINK_HIGHEXPER :: 158;

IN_CLASSA_NET    :: 0xff000000;
IN_CLASSA_NSHIFT :: 24;
IN_CLASSA_HOST   :: 0x00ffffff;
IN_CLASSA_MAX    :: 128;
IN_CLASSB_NET    :: 0xffff0000;
IN_CLASSB_NSHIFT :: 16;
IN_CLASSB_HOST   :: 0x0000ffff;
IN_CLASSB_MAX    :: 65536;
IN_CLASSC_NET    :: 0xffffff00;
IN_CLASSC_NSHIFT :: 8;
IN_CLASSC_HOST   :: 0x000000ff;

IP_OPTIONS         :: 1;
IP_MULTICAST_IF    :: 2;
IP_MULTICAST_TTL   :: 3;
IP_MULTICAST_LOOP  :: 4;
IP_ADD_MEMBERSHIP  :: 5;
IP_DROP_MEMBERSHIP :: 6;
IP_TTL             :: 7;
IP_TOS             :: 8;
IP_DONTFRAGMENT    :: 9;

IP_DEFAULT_MULTICAST_TTL  :: 1;
IP_DEFAULT_MULTICAST_LOOP :: 1;
IP_MAX_MEMBERSHIPS        :: 20;

INADDR_ANY       : u_long : 0x00000000;
INADDR_BROADCAST : u_long : 0xffffffff;
INADDR_LOOPBACK          :: 0x7f000001;
INADDR_NONE              :: 0xffffffff;

WSADESCRIPTION_LEN :: 256;
WSASYS_STATUS_LEN  :: 128;

LPWSADATA :: ^WSADATA;

SOCK_STREAM    :: 1;
SOCK_DGRAM     :: 2;
SOCK_RAW       :: 3;
SOCK_RDM       :: 4;
SOCK_SEQPACKET :: 5;

SO_DEBUG       :: 0x0001;
SO_ACCEPTCONN  :: 0x0002;
SO_REUSEADDR   :: 0x0004;
SO_KEEPALIVE   :: 0x0008;
SO_DONTROUTE   :: 0x0010;
SO_BROADCAST   :: 0x0020;
SO_USELOOPBACK :: 0x0040;
SO_LINGER      :: 0x0080;
SO_OOBINLINE   :: 0x0100;

SO_DONTLINGER :: ~cast(u64)SO_LINGER;

SO_SNDBUF   :: 0x1001;
SO_RCVBUF   :: 0x1002;
SO_SNDLOWAT :: 0x1003;
SO_RCVLOWAT :: 0x1004;
SO_SNDTIMEO :: 0x1005;
SO_RCVTIMEO :: 0x1006;
SO_ERROR    :: 0x1007;
SO_TYPE     :: 0x1008;

SO_CONNDATA    :: 0x7000;
SO_CONNOPT     :: 0x7001;
SO_DISCDATA    :: 0x7002;
SO_DISCOPT     :: 0x7003;
SO_CONNDATALEN :: 0x7004;
SO_CONNOPTLEN  :: 0x7005;
SO_DISCDATALEN :: 0x7006;
SO_DISCOPTLEN  :: 0x7007;

SO_OPENTYPE :: 0x7008;

SO_SYNCHRONOUS_ALERT    :: 0x10;
SO_SYNCHRONOUS_NONALERT :: 0x20;

SO_MAXDG                 :: 0x7009;
SO_MAXPATHDG             :: 0x700A;
SO_UPDATE_ACCEPT_CONTEXT :: 0x700B;
SO_CONNECT_TIME          :: 0x700C;

SD_SEND :: 0x01;

TCP_NODELAY   :: 0x0001;
TCP_BSDURGENT :: 0x7000;

// Address families
AF_UNSPEC    :: 0;
AF_UNIX      :: 1;
AF_INET      :: 2;
AF_IMPLINK   :: 3;
AF_PUP       :: 4;
AF_CHAOS     :: 5;
AF_IPX       :: 6;
AF_NS        :: 6;
AF_ISO       :: 7;
AF_OSI       :: AF_ISO;
AF_ECMA      :: 8;
AF_DATAKIT   :: 9;
AF_CCITT     :: 10;
AF_SNA       :: 11;
AF_DECnet    :: 12;
AF_DLI       :: 13;
AF_LAT       :: 14;
AF_HYLINK    :: 15;
AF_APPLETALK :: 16;
AF_NETBIOS   :: 17;
AF_VOICEVIEW :: 18;
AF_FIREFOX   :: 19;
AF_UNKNOWN1  :: 20;
AF_BAN       :: 21;
AF_MAX       :: 22;

PF_UNSPEC    :: AF_UNSPEC;
PF_UNIX      :: AF_UNIX;
PF_INET      :: AF_INET;
PF_IMPLINK   :: AF_IMPLINK;
PF_PUP       :: AF_PUP;
PF_CHAOS     :: AF_CHAOS;
PF_NS        :: AF_NS;
PF_IPX       :: AF_IPX;
PF_ISO       :: AF_ISO;
PF_OSI       :: AF_OSI;
PF_ECMA      :: AF_ECMA;
PF_DATAKIT   :: AF_DATAKIT;
PF_CCITT     :: AF_CCITT;
PF_SNA       :: AF_SNA;
PF_DECnet    :: AF_DECnet;
PF_DLI       :: AF_DLI;
PF_LAT       :: AF_LAT;
PF_HYLINK    :: AF_HYLINK;
PF_APPLETALK :: AF_APPLETALK;
PF_VOICEVIEW :: AF_VOICEVIEW;
PF_FIREFOX   :: AF_FIREFOX;
PF_UNKNOWN1  :: AF_UNKNOWN1;
PF_BAN       :: AF_BAN;

PF_MAX :: AF_MAX;

SOL_SOCKET :: 0xffff;

SOMAXCONN :: 0x7fffffff;

MSG_OOB       :: 0x1;
MSG_PEEK      :: 0x2;
MSG_DONTROUTE :: 0x4;
MSG_MAXIOVLEN :: 16;
MSG_PARTIAL   :: 0x8000;

MAXGETHOSTSTRUCT :: 1024;

FD_READ    :: 0x01;
FD_WRITE   :: 0x02;
FD_OOB     :: 0x04;
FD_ACCEPT  :: 0x08;
FD_CONNECT :: 0x10;
FD_CLOSE   :: 0x20;

TF_DISCONNECT   :: 0x01;
TF_REUSE_SOCKET :: 0x02;
TF_WRITE_BEHIND :: 0x04;

// Windows Sockets error codes
WSABASEERR :: 10000;

WSAEINTR  :: WSABASEERR + 4;
WSAEBADF  :: WSABASEERR + 9;
WSAEACCES :: WSABASEERR + 13;
WSAEFAULT :: WSABASEERR + 14;
WSAEINVAL :: WSABASEERR + 22;
WSAEMFILE :: WSABASEERR + 24;

// Berkeley error codes
WSAEWOULDBLOCK     :: WSABASEERR + 35;
WSAEINPROGRESS     :: WSABASEERR + 36;
WSAEALREADY        :: WSABASEERR + 37;
WSAENOTSOCK        :: WSABASEERR + 38;
WSAEDESTADDRREQ    :: WSABASEERR + 39;
WSAEMSGSIZE        :: WSABASEERR + 40;
WSAEPROTOTYPE      :: WSABASEERR + 41;
WSAENOPROTOOPT     :: WSABASEERR + 42;
WSAEPROTONOSUPPORT :: WSABASEERR + 43;
WSAESOCKTNOSUPPORT :: WSABASEERR + 44;
WSAEOPNOTSUPP      :: WSABASEERR + 45;
WSAEPFNOSUPPORT    :: WSABASEERR + 46;
WSAEAFNOSUPPORT    :: WSABASEERR + 47;
WSAEADDRINUSE      :: WSABASEERR + 48;
WSAEADDRNOTAVAIL   :: WSABASEERR + 49;
WSAENETDOWN        :: WSABASEERR + 50;
WSAENETUNREACH     :: WSABASEERR + 51;
WSAENETRESET       :: WSABASEERR + 52;
WSAECONNABORTED    :: WSABASEERR + 53;
WSAECONNRESET      :: WSABASEERR + 54;
WSAENOBUFS         :: WSABASEERR + 55;
WSAEISCONN         :: WSABASEERR + 56;
WSAENOTCONN        :: WSABASEERR + 57;
WSAESHUTDOWN       :: WSABASEERR + 58;
WSAETOOMANYREFS    :: WSABASEERR + 59;
WSAETIMEDOUT       :: WSABASEERR + 60;
WSAECONNREFUSED    :: WSABASEERR + 61;
WSAELOOP           :: WSABASEERR + 62;
WSAENAMETOOLONG    :: WSABASEERR + 63;
WSAEHOSTDOWN       :: WSABASEERR + 64;
WSAEHOSTUNREACH    :: WSABASEERR + 65;
WSAENOTEMPTY       :: WSABASEERR + 66;
WSAEPROCLIM        :: WSABASEERR + 67;
WSAEUSERS          :: WSABASEERR + 68;
WSAEDQUOT          :: WSABASEERR + 69;
WSAESTALE          :: WSABASEERR + 70;
WSAEREMOTE         :: WSABASEERR + 71;

WSAEDISCON :: WSABASEERR + 101;

// Extended error codes
WSASYSNOTREADY     :: WSABASEERR + 91;
WSAVERNOTSUPPORTED :: WSABASEERR + 92;
WSANOTINITIALISED  :: WSABASEERR + 93;

WSAHOST_NOT_FOUND           :: WSABASEERR + 1001;
WSATRY_AGAIN                :: WSABASEERR + 1002;
WSANO_RECOVERY              :: WSABASEERR + 1003;
WSANO_DATA                  :: WSABASEERR + 1004;
WSA_SECURE_HOST_NOT_FOUND   :: WSABASEERR + 1032;
WSA_IPSEC_NAME_POLICY_ERROR :: WSABASEERR + 1033;

// Compatibility
h_errno        :: WSAGetLastError;
HOST_NOT_FOUND :: WSAHOST_NOT_FOUND;
TRY_AGAIN      :: WSATRY_AGAIN;
NO_RECOVERY    :: WSANO_RECOVERY;
NO_DATA        :: WSANO_DATA;
WSANO_ADDRESS  :: WSANO_DATA;
NO_ADDRESS     :: WSANO_ADDRESS;

// __CLASSA_FLAG : c.long : 0x80000000;
// __CLASSB_FLAG : c.long : 0xc0000000;
// __CLASSC_FLAG : c.long : 0xe0000000;

// Functions
// IN_CLASSA :: #force_inline proc(i: c.long) -> bool { return (cast(c.long)i & __CLASSA_FLAG) == 0;             }
// IN_CLASSB :: #force_inline proc(i: c.long) -> bool { return (cast(c.long)i & __CLASSB_FLAG) == __CLASSA_FLAG; }
// IN_CLASSC :: #force_inline proc(i: c.long) -> bool { return (cast(c.long)i & __CLASSC_FLAG) == __CLASSB_FLAG; }

// Structs
timeval :: struct {
    tv_sec  : c.long,
    tv_usec : c.long,
}

hostent :: struct {
    h_name      : cstring,
    h_aliases   : ^cstring,
    h_addrtype  : c.short,
    h_length    : c.short,
    h_addr_list : ^cstring,
}

netent :: struct {
    n_name     : ^cstring,
    n_aliases  : ^cstring,
    n_addrtype : c.short,
    n_net      : u_long,
}

servent :: struct {
    s_name    : cstring,
    s_aliases : ^cstring,
    s_port    : c.short,
    s_proto   : cstring,
}

protoent :: struct {
    p_name    : cstring,
    p_aliases : ^cstring,
    p_proto   : c.short,
}

sockaddr_in :: struct {
    sin_family : c.short,
    sin_port   : u_short,
    sin_addr   : in_addr,
    sin_zero   : [8]c.char,
}

sockaddr :: struct {
    sa_family : u_short,
    sa_data   : [14]c.char,
}

ip_mreq :: struct {
    imr_multiaddr: in_addr,
    imr_interface: in_addr,
}

in_addr :: struct {
    using _: struct #raw_union {
        s_un_b: struct {
            s_b1: u_char,
            s_b2: u_char,
            s_b3: u_char,
            s_b4: u_char,
        },
        s_un_w: struct  {
            s_w1: u_short,
            s_w2: u_short,
        },
        s_addr: u_long,
    },
}

sockproto :: struct {
    sp_family   : u_short,
    sp_protocol : u_short,
}

fd_set :: struct {
    fd_count: u_int,
    fd_array: [FD_SETSIZE]SOCKET,
}

linger :: struct {
    l_onoff  : u_short,
    l_linger : u_short,
}

WSADATA :: struct {
    wVersion       : WORD,
    wHighVersion   : WORD,
    szDescription  : [WSADESCRIPTION_LEN + 1]c.char,
    szSystemStatus : [WSADESCRIPTION_LEN + 1]c.char,
    iMaxSockets    : c.ushort,
    iMaxUdpDg      : c.ushort,
    lpVendorInfo   : cstring,
}

TRANSMIT_FILE_BUFFERS :: struct {
    Head       : rawptr,
    HeadLength : DWORD,
    Tail       : rawptr,
    TailLength : DWORD,
}

// @Note(Judah): This is already defined in sys/windows
// OVERLAPPED :: struct {
//     Internal     : *u_long;
//     InternalHigh : *u_long;
//     union {
//         struct {
//             Offset     : DWORD;
//             OffsetHigh : DWORD;
//         };
//     };
//     Pointer : *void;
//     hEvent  : HANDLE;
// };


// WSA specific functions
@(default_calling_convention = "stdcall")
foreign winsock2 {
    WSAStartup               :: proc(wVersionRequired: WORD, lpWSAData: ^WSADATA)                                                  -> c.int  ---
    WSACleanup               :: proc()                                                                                             -> c.int  ---
    WSASetLastError          :: proc(iError: c.int)                                                                                -> c.int  ---
    WSAGetLastError          :: proc()                                                                                             -> c.int  ---
    WSAIsBlocking            :: proc()                                                                                             -> bool   ---
    WSAUnhookBlockingHook    :: proc()                                                                                             -> c.int  ---
    WSACancelBlockingCall    :: proc()                                                                                             -> c.int  ---
    WSAAsyncGetServByName    :: proc(hWnd: HWND, wMsg: u_int, name: cstring, proto: cstring, buf: cstring, buflen: c.int)          -> HANDLE ---
    WSAAsyncGetServByPort    :: proc(hWnd: HWND, wMsg: u_int, port: c.int, proto: cstring, buf: cstring, buglen: c.int)            -> HANDLE ---
    WSAAsyncGetProtoByName   :: proc(hWnd: HWND, wMsg: u_int, name: cstring, buf: cstring, buflen: c.int)                          -> HANDLE ---
    WSAAsyncGetProtoByNumber :: proc(hWnd: HWND, wMsg: u_int, number: c.int, buf: cstring, buflen: c.int)                          -> HANDLE ---
    WSAAsyncGetHostByName    :: proc(hWnd: HWND, wMsg: u_int, name: cstring, buf: cstring, buflen: c.int)                          -> HANDLE ---
    WSAAsyncGetHostByAddr    :: proc(hWnd: HWND, wMsg: u_int, addr: cstring, len: c.int, type: c.int, buf: cstring, buflen: c.int) -> HANDLE ---

    WSACancelAsyncRequest :: proc(hAsyncTaskHandle: HANDLE)                                                                                                                                                                                                        -> c.int ---
    WSAAsyncSelect        :: proc(s: SOCKET, hWnd: HWND, wMsg: u_int, lEvent: c.long)                                                                                                                                                                              -> c.int ---
    WSARecvEx             :: proc(s: SOCKET, buf: cstring, len: c.int, flags: ^c.int)                                                                                                                                                                              -> c.int ---
    TransmitFile          :: proc(hSocket: SOCKET, hFile: HANDLE, nNumberOfBytesToWrite: DWORD, nNumberOfBytesPerSend: DWORD, lpOverlapped: ^OVERLAPPED, lpTransmitBuffers: ^TRANSMIT_FILE_BUFFERS, dwReserved: DWORD)                                             -> bool  ---
    AcceptEx              :: proc(sListenSocket: SOCKET, sAcceptSocket: SOCKET, lpOutputBuffer: rawptr, dwReceiveDataLength: DWORD, dwLocalAddressLength: DWORD, dwRemoteAddressLength: DWORD, lpdwBytesReceived: ^DWORD, lpOverlapped: ^OVERLAPPED)               -> bool  ---
    GetAcceptExSockaddrs  :: proc(lpOutputBuffer: rawptr, dwReceiveDataLength: DWORD, dwLocalAddressLength: DWORD, dwRemoteAddressLength: DWORD, LocalSockaddr: ^^sockaddr, LocalSockaddrLength: ^c.int, RemoteSockaddr: ^^sockaddr, RemoteSockaddrLength: ^c.int)          ---

    socket      :: proc(af: c.int, type: c.int, protocol: c.int)                                                 -> SOCKET ---
    accept      :: proc(s: SOCKET, addr: ^sockaddr, addrlen: ^c.int)                                             -> SOCKET ---
    bind        :: proc(s: SOCKET, addr: ^sockaddr, namelen: c.int)                                              -> c.int  ---
    closesocket :: proc(s: SOCKET)                                                                               -> c.int  ---
    getpeername :: proc(s: SOCKET, name: ^sockaddr, namelen: ^c.int)                                             -> c.int  ---
    getsockname :: proc(s: SOCKET, name: ^sockaddr, namelen: ^c.int)                                             -> c.int  ---
    listen      :: proc(s: SOCKET, backlog: c.int)                                                               -> c.int  ---
    recvfrom    :: proc(s: SOCKET, buf: rawptr, len: c.int, flags: c.int, from: ^sockaddr, fromlen: ^c.int)      -> c.int  ---
    recv        :: proc(s: SOCKET, buf: rawptr, len: c.int, flags: c.int)                                        -> c.int  ---
    select      :: proc(nfds: c.int, readfds: ^fd_set, writefds: ^fd_set, exceptfds: ^fd_set, timeout: ^timeval) -> c.int  ---
    send        :: proc(s: SOCKET, buf: rawptr, len: c.int, flags: c.int)                                        -> c.int  ---
    sendto      :: proc(s: SOCKET, buf: rawptr, len: c.int, flags: c.int, to: ^sockaddr, tolen: c.int)           -> c.int  ---

    // optval should actually be a cstring but ws2_32 collides with this if it is defined as such.
    setsockopt  :: proc(s: SOCKET, level: c.int, optname: c.int, optval: rawptr, optlen: c.int)                 -> c.int  ---

    shutdown    :: proc(s: SOCKET, how: c.int)                                                                   -> c.int  ---
    connect     :: proc(s: SOCKET, name: ^sockaddr, namelen: c.int)                                              -> c.int  ---

    // Note: Declarations that cause collisions with sys/windows/ws2_32
    // getsockopt  :: proc(s: SOCKET, level: c.int, optname: c.int, optval: cstring, optlen: c.int)                 -> c.int  ---
    // ioctlsocket :: proc(s: SOCKET, cmd: c.longlong, argp: ^u_long)                                               -> c.int  ---

    gethostbyaddr    :: proc(addr: cstring, len: c.int, type: c.int) -> ^hostent  ---
    gethostbyname    :: proc(name: cstring)                          -> ^hostent  ---
    gethostname      :: proc(name: cstring, namelen: c.int)          -> c.int     ---
    getservbyport    :: proc(port: c.int, proto: cstring)            -> ^servent  ---
    getservbyname    :: proc(name: cstring, proto: cstring)          -> ^servent  ---
    getprotobynumber :: proc(proto: c.int)                           -> ^protoent ---
    getprotobyname   :: proc(name: cstring)                          -> ^protoent ---

    inet_addr :: proc(cp: cstring)  -> c.ulong ---
    inet_ntoa :: proc(_in: in_addr) -> cstring ---

    htonl :: proc(hostlong: u_long)   -> u_long  ---
    htons :: proc(hostshort: u_short) -> u_short ---
    ntohl :: proc(netlong: u_long)    -> u_long  ---
    ntohs :: proc(netshort: u_short)  -> u_short ---
}


// === Winsock2 ===
// === Public API ===

// Defines
WSAEVENT :: HANDLE;
GROUP    :: c.uint;
ADDR_ANY :: INADDR_ANY;
WSACOMPLETIONTYPE :: c.uint;

SO_EXCLUSIVEADDRUSE :: ~cast(u16)SO_REUSEADDR;

SO_GROUP_ID       :: 0x2001;
SO_GROUP_PRIORITY :: 0x2002;
SO_MAX_MSG_SIZE   :: 0x2003;
SO_PROTOCOL_INFOA :: 0x2004;
SO_PROTOCOL_INFOW :: 0x2005;

FROM_PROTOCOL_INFO :: -1;

PVD_CONFIG            :: 0x3001;
SO_CONDITIONAL_ACCEPT :: 0x3002;

MSG_PUSH_IMMEDIATE :: 0x20;
MSG_WAITALL        :: 0x8;
MSG_INTERRUPT      :: 0x10;

FD_READ_BIT      :: 0;
FD_WRITE_BIT     :: 1;
FD_OOB_BIT       :: 2;
FD_ACCEPT_BIT    :: 3;
FD_CONNECT_BIT   :: 4;
FD_CLOSE_BIT     :: 5;
FD_QOS_BIT       :: 6;
FD_GROUP_QOS_BIT :: 7;

// @Note(Judah): These are already defined in winsock1.
// However, winsock2 changes their definitions to be:

// FD_READ          :: 1 << FD_READ_BIT;
// FD_WRITE         :: 1 << FD_WRITE_BIT;
// FD_OOB           :: 1 << FD_OOB_BIT;
// FD_ACCEPT        :: 1 << FD_ACCEPT_BIT;
// FD_CONNECT       :: 1 << FD_CONNECT_BIT;
// FD_CLOSE         :: 1 << FD_CLOSE_BIT;
// FD_QOS           :: 1 << FD_QOS_BIT;
// FD_GROUP_QOS     :: 1 << FD_GROUP_QOS_BIT;


FD_ROUTING_INTERFACE_CHANGE_BIT :: 8;
FD_ROUTING_INTERFACE_CHANGE     :: 1 << FD_ROUTING_INTERFACE_CHANGE_BIT;
FD_ADDRESS_LIST_CHANGE_BIT      :: 9;
FD_ADDRESS_LIST_CHANGE          :: 1 << FD_ADDRESS_LIST_CHANGE_BIT;
FD_MAX_EVENTS                   :: 10;
FD_ALL_EVENTS                   :: (1 << FD_MAX_EVENTS) - 1;

CONDITIONPROC                    :: #type proc(lpCallerId: ^WSABUF, lpCallerData: ^WSABUF, lpSQOS: ^QOS, lpGQOS: ^QOS, lpCalleeId: ^WSABUF, lpCalleeData: ^WSABUF, g: ^GROUP, dwCallbackData: ^DWORD) -> c.int;
WSAOVERLAPPED_COMPLETION_ROUTINE :: #type proc(dwError: DWORD, cbTransferred: DWORD, lpOverlapped: ^WSAOVERLAPPED, dwFlags: DWORD);

// Extended error codes
WSAENOMORE             :: WSABASEERR + 102;
WSAECANCELLED          :: WSABASEERR + 103;
WSAEINVALIDPROCTABLE   :: WSABASEERR + 104;
WSAEINVALIDPROVIDER    :: WSABASEERR + 105;
WSAEPROVIDERFAILEDINIT :: WSABASEERR + 106;
WSASYSCALLFAILURE      :: WSABASEERR + 107;
WSASERVICE_NOT_FOUND   :: WSABASEERR + 108;
WSATYPE_NOT_FOUND      :: WSABASEERR + 109;
WSA_E_NO_MORE          :: WSABASEERR + 110;
WSA_E_CANCELLED        :: WSABASEERR + 111;
WSAEREFUSED            :: WSABASEERR + 112;

WSA_QOS_RECEIVERS          :: WSABASEERR + 1005;
WSA_QOS_SENDERS            :: WSABASEERR + 1006;
WSA_QOS_NO_SENDERS         :: WSABASEERR + 1007;
WSA_QOS_NO_RECEIVERS       :: WSABASEERR + 1008;
WSA_QOS_REQUEST_CONFIRMED  :: WSABASEERR + 1009;
WSA_QOS_ADMISSION_FAILURE  :: WSABASEERR + 1010;
WSA_QOS_POLICY_FAILURE     :: WSABASEERR + 1011;
WSA_QOS_BAD_STYLE          :: WSABASEERR + 1012;
WSA_QOS_BAD_OBJECT         :: WSABASEERR + 1013;
WSA_QOS_TRAFFIC_CTRL_ERROR :: WSABASEERR + 1014;
WSA_QOS_GENERIC_ERROR      :: WSABASEERR + 1015;
WSA_QOS_ESERVICETYPE       :: WSABASEERR + 1016;
WSA_QOS_EFLOWSPEC          :: WSABASEERR + 1017;
WSA_QOS_EPROVSPECBUF       :: WSABASEERR + 1018;
WSA_QOS_EFILTERSTYLE       :: WSABASEERR + 1019;
WSA_QOS_EFILTERTYPE        :: WSABASEERR + 1020;
WSA_QOS_EFILTERCOUNT       :: WSABASEERR + 1021;
WSA_QOS_EOBJLENGTH         :: WSABASEERR + 1022;
WSA_QOS_EFLOWCOUNT         :: WSABASEERR + 1023;
WSA_QOS_EUNKOWNPSOBJ       :: WSABASEERR + 1024;
WSA_QOS_EPOLICYOBJ         :: WSABASEERR + 1025;
WSA_QOS_EFLOWDESC          :: WSABASEERR + 1026;
WSA_QOS_EPSFLOWSPEC        :: WSABASEERR + 1027;
WSA_QOS_EPSFILTERSPEC      :: WSABASEERR + 1028;
WSA_QOS_ESDMODEOBJ         :: WSABASEERR + 1029;
WSA_QOS_ESHAPERATEOBJ      :: WSABASEERR + 1030;
WSA_QOS_RESERVED_PETYPE    :: WSABASEERR + 1031;

WSA_IO_PENDING          :: WSAEWOULDBLOCK;
WSA_IO_INCOMPLETE       :: WSAEWOULDBLOCK;
WSA_INVALID_HANDLE      :: WSAENOTSOCK;
WSA_INVALID_PARAMETER   :: WSAEINVAL;
WSA_NOT_ENOUGH_MEMORY   :: WSAENOBUFS;
WSA_OPERATION_ABORTED   :: WSAEINTR;
MAXIMUM_WAIT_OBJECTS    :: 64;
WSA_MAXIMUM_WAIT_EVENTS :: MAXIMUM_WAIT_OBJECTS;
WSA_WAIT_FAILED         :: -1;
WSA_INFINITE            :: -1;
WSA_WAIT_EVENT_0        : DWORD : 0;
WSA_WAIT_TIMEOUT        : DWORD : 0x102;
WSA_INVALID_EVENT       : WSAEVENT;

WSAPROTOCOL_LEN :: 255;

CF_ACCEPT :: 0x0000;
CF_REJECT :: 0x0001;
CF_DEFER  :: 0x0002;

SG_UNCONSTRAINED_GROUP :: 0x01;
SG_CONSTRAINED_GROUP   :: 0x02;

MAX_PROTOCOL_CHAIN :: 7;
BASE_PROTOCOL      :: 1;
LAYERED_PROTOCOL   :: 0;

PFL_MULTIPLE_PROTO_ENTRIES  :: 0x00000001;
PFL_RECOMMENDED_PROTO_ENTRY :: 0x00000002;
PFL_HIDDEN                  :: 0x00000004;
PFL_MATCHES_PROTOCOL_ZERO   :: 0x00000008;
PFL_NETWORKDIRECT_PROVIDER  :: 0x00000010;

XP1_CONNECTIONLESS           :: 0x00000001;
XP1_GUARANTEED_DELIVERY      :: 0x00000002;
XP1_GUARANTEED_ORDER         :: 0x00000004;
XP1_MESSAGE_ORIENTED         :: 0x00000008;
XP1_PSEUDO_STREAM            :: 0x00000010;
XP1_GRACEFUL_CLOSE           :: 0x00000020;
XP1_EXPEDITED_DATA           :: 0x00000040;
XP1_CONNECT_DATA             :: 0x00000080;
XP1_DISCONNECT_DATA          :: 0x00000100;
XP1_SUPPORT_BROADCAST        :: 0x00000200;
XP1_SUPPORT_MULTIPOINT       :: 0x00000400;
XP1_MULTIPOINT_CONTROL_PLANE :: 0x00000800;
XP1_MULTIPOINT_DATA_PLANE    :: 0x00001000;
XP1_QOS_SUPPORTED            :: 0x00002000;
XP1_INTERRUPT                :: 0x00004000;
XP1_UNI_SEND                 :: 0x00008000;
XP1_UNI_RECV                 :: 0x00010000;
XP1_IFS_HANDLES              :: 0x00020000;
XP1_PARTIAL_MESSAGE          :: 0x00040000;
XP1_SAN_SUPPORT_SDP          :: 0x00080000;

BIGENDIAN              :: 0x0000;
LITTLEENDIAN           :: 0x0001;
SECURITY_PROTOCOL_NONE :: 0x0000;

JL_SENDER_ONLY   :: 0x01;
JL_RECEIVER_ONLY :: 0x02;
JL_BOTH          :: 0x04;

WSA_FLAG_OVERLAPPED             :: 0x01;
WSA_FLAG_MULTIPOINT_C_ROOT      :: 0x02;
WSA_FLAG_MULTIPOINT_C_LEAF      :: 0x04;
WSA_FLAG_MULTIPOINT_D_ROOT      :: 0x08;
WSA_FLAG_MULTIPOINT_D_LEAF      :: 0x10;
WSA_FLAG_ACCESS_SYSTEM_SECURITY :: 0x40;
WSA_FLAG_NO_HANDLE_INHERIT      :: 0x80;
WSA_FLAG_REGISTERED_IO          :: 0x100;

TH_NETDEV :: 0x00000001;
TH_TAPI   :: 0x00000002;

SERVICE_MULTIPLE :: 0x00000001;

NS_ALL         :: 0;
NS_SAP         :: 1;
NS_NDS         :: 2;
NS_PEER_BROWSE :: 3;
NS_SLP         :: 5;
NS_DHCP        :: 6;
NS_TCPIP_LOCAL :: 0;
NS_TCPIP_HOSTS :: 1;
NS_DNS         :: 2;
NS_NETBT       :: 3;
NS_WINS        :: 4;
NS_NLA         :: 15;
NS_BTH         :: 16;
NS_NBP         :: 20;
NS_MS          :: 30;
NS_STDA        :: 31;
NS_NTDS        :: 32;
NS_EMAIL       :: 37;
NS_PNRPNAME    :: 38;
NS_PNRPCLOUD   :: 39;
NS_X500        :: 40;
NS_NIS         :: 41;
NS_NISPLUS     :: 42;
NS_WRQ         :: 50;
NS_NETDES      :: 60;

RES_UNUSED_1    :: 0x00000001;
RES_FLUSH_CACHE :: 0x00000002;
RES_SERVICE     :: 0x00000004;

SERVICE_TYPE_VALUE_IPXPORT  :: "IpxSocket";
SERVICE_TYPE_VALUE_SAPID    :: "SapId";
SERVICE_TYPE_VALUE_TCPPORT  :: "TcpPort";
SERVICE_TYPE_VALUE_UDPPORT  :: "UdpPort";
SERVICE_TYPE_VALUE_OBJECTID :: "ObjectId";

LUP_DEEP                :: 0x0001;
LUP_CONTAINERS          :: 0x0002;
LUP_NOCONTAINERS        :: 0x0004;
LUP_NEAREST             :: 0x0008;
LUP_RETURN_NAME         :: 0x0010;
LUP_RETURN_TYPE         :: 0x0020;
LUP_RETURN_VERSION      :: 0x0040;
LUP_RETURN_COMMENT      :: 0x0080;
LUP_RETURN_ADDR         :: 0x0100;
LUP_RETURN_BLOB         :: 0x0200;
LUP_RETURN_ALIASES      :: 0x0400;
LUP_RETURN_QUERY_STRING :: 0x0800;
LUP_RETURN_ALL          :: 0x0FF0;
LUP_RES_SERVICE         :: 0x8000;

LUP_FLUSHCACHE          :: 0x1000;
LUP_FLUSHPREVIOUS       :: 0x2000;

LUP_NON_AUTHORITATIVE      :: 0x4000;
LUP_SECURE                 :: 0x8000;
LUP_RETURN_PREFERRED_NAMES :: 0x10000;
LUP_DNS_ONLY               :: 0x20000;

LUP_ADDRCONFIG           :: 0x00100000;
LUP_DUAL_ADDR            :: 0x00200000;
LUP_FILESERVER           :: 0x00400000;
LUP_DISABLE_IDN_ENCODING :: 0x00800000;
LUP_API_ANSI             :: 0x01000000;
LUP_RESOLUTION_HANDLE    :: 0x80000000;

RESULT_IS_ADDED   :: 0x0010;
RESULT_IS_CHANGED :: 0x0020;
RESULT_IS_DELETED :: 0x0040;

POLLRDNORM :: 0x0100;
POLLRDBAND :: 0x0200;
POLLIN     :: POLLRDNORM | POLLRDBAND;
POLLPRI    :: 0x0400;
POLLWRNORM :: 0x0010;
POLLOUT    :: POLLWRNORM;
POLLWRBAND :: 0x0020;
POLLERR    :: 0x0001;
POLLHUP    :: 0x0002;
POLLNVAL   :: 0x0004;

// Enums
WSAECOMPARATOR :: enum {
    COMP_EQUAL = 0,
    COMP_NOTLESS,
}

WSAESETSERVICEOP :: enum {
    RNRSERVICE_REGISTER = 0,
    RNRSERVICE_DEREGISTER,
    RNRSERVICE_DELETE,
}

// Structs
WSAOVERLAPPED :: struct {
    Internal     : DWORD,
    InternalHigh : DWORD,
    Offset       : DWORD,
    OffsetHigh   : DWORD,
    hEvent       : WSAEVENT,
}

WSANETWORKEVENTS :: struct {
    lNetworkEvents : c.long,
    iErrorCode     : [FD_MAX_EVENTS]c.int,
}

WSAPROTOCOLCHAIN :: struct {
    ChainLen     : c.int,
    ChainEntries : [MAX_PROTOCOL_CHAIN]DWORD,
}

WSAPROTOCOL_INFO :: struct {
    dwServiceFlags1    : DWORD,
    dwServiceFlags2    : DWORD,
    dwServiceFlags3    : DWORD,
    dwServiceFlags4    : DWORD,
    dwProviderFlags    : DWORD,
    ProviderId         : GUID,
    dwCatalogEntryId   : DWORD,
    ProtocolChain      : WSAPROTOCOLCHAIN,
    iVersion           : c.int,
    iAddressFamily     : c.int,
    iMaxSockAddr       : c.int,
    iMinSockAddr       : c.int,
    iSocketType        : c.int,
    iProtocol          : c.int,
    iProtocolMaxOffset : c.int,
    iNetworkByteOrder  : c.int,
    iSecurityScheme    : c.int,
    dwMessageSize      : DWORD,
    dwProviderReserved : DWORD,
    szProtocol         : [WSAPROTOCOL_LEN + 1]WCHAR,
}

AFPROTOCOLS :: struct {
    iAddressFamily : c.int,
    iProtocol      : c.int,
}

WSAVERSION :: struct {
    dwVersion : DWORD,
    ecHow     : WSAECOMPARATOR,
}

WSAQUERYSET :: struct {
    dwSize                  : DWORD,
    lpszServiceInstanceName : ^WSTR,
    lpServiceClassId        : ^GUID,
    lpVersion               : ^WSAVERSION,
    lpszComment             : ^WSTR,
    dwNameSpace             : DWORD,
    lpNSProviderId          : ^GUID,
    lpszContext             : ^WSTR,
    dwNumberOfProtocols     : DWORD,
    lpafpProtocols          : ^AFPROTOCOLS,
    lpszQueryString         : ^WSTR,
    dwNumberOfCsAddrs       : DWORD,
    dwOutputFlags           : DWORD,
    lpBlob                  : ^BLOB,
}

WSANSCLASSINFO :: struct {
    lpszName    : ^WSTR,
    dwNameSpace : DWORD,
    dwValueType : DWORD,
    dwValueSize : DWORD,
    lpValue     : rawptr,
}

WSASERVICECLASSINFO :: struct {
    lpServiceClassId     : ^GUID,
    lpszServiceClassName : LPSTR,
    dwCount              : DWORD,
    lpClassInfos         : ^WSANSCLASSINFO,
}

WSANAMESPACE_INFO :: struct {
    NSProviderId   : GUID,
    dwNameSpace    : DWORD,
    fActive        : bool,
    dwVersion      : DWORD,
    lpszIdentifier : ^WSTR,
}

WSANAMESPACE_INFOEX :: struct {
    NSProviderId     : GUID,
    dwNameSpace      : DWORD,
    fActive          : bool,
    dwVersion        : DWORD,
    lpszIdentifier   : ^WSTR,
    ProviderSpecific : BLOB,
}

WSAPOLLFD :: struct {
    fd      : SOCKET,
    events  : c.short,
    revents : c.short,
}

WSABUF :: struct {
    len: c.ulong,
    buf: cstring,
}

WSACOMPLETION :: struct {
    Type: WSACOMPLETIONTYPE,
    Parameters: struct #raw_union {
        WindowMessage: struct {
            hWnd : HWND,
            uMsg : c.uint,
            ctx  : WPARAM,
        },
        Event: struct {
            lpOverlapped : ^WSAOVERLAPPED,
        },
        Apc: struct {
            lpOverlapped  : ^WSAOVERLAPPED,
            lpfnCondition : ^WSAOVERLAPPED_COMPLETION_ROUTINE,
        },
        Port: struct {
            lpOverlapped: ^WSAOVERLAPPED,
            hPort: HANDLE,
            Key: ^c.ulong,
        },
    },
}

WSAMSG :: struct {
    name          : ^SOCKADDR,
    namelen       : c.int,
    lpBuffers     : ^WSABUF,
    dwBufferCount : c.ulong,
    Control       : WSABUF,
    dwFlags       : c.ulong,
}

QOS :: struct {
    SendingFlowspec   : FLOWSPEC,
    ReceivingFlowspec : FLOWSPEC,
    ProviderSpecific  : WSABUF,
}

// From qos.h
SERVICETYPE :: c.ulong;

FLOWSPEC :: struct {
    TokenRate          : c.ulong,
    TokenBucketSize    : c.ulong,
    PeakBandwidth      : c.ulong,
    Latency            : c.ulong,
    DelayVariation     : c.ulong,
    ServiceType        : SERVICETYPE,
    MaxSduSize         : c.ulong,
    MinimumPolicedSize : c.ulong,
}

BLOB :: struct {
    cbSize    : c.ulong,
    pBlobData : ^BYTE,
}

SOCKET_ADDRESS_LIST :: struct {
    iAddressCount : c.int,
    Address       : [1]SOCKADDR,
}

_WS2_32_WINSOCK_SWAP_LONG :: #force_inline proc "c" (l: c.ulong) -> c.ulong {
    return (((l >> 24) & 0x000000FF) |
            ((l >>  8) & 0x0000FF00) |
            ((l <<  8) & 0x00FF0000) |
            ((l << 24) & 0xFF000000) );
}

_WS2_32_WINSOCK_SWAP_LONGLONG :: #force_inline proc "c" (l: c.ulonglong) -> c.ulonglong {
    return (((l >> 56) & 0x00000000000000FF) |
            ((l >> 40) & 0x000000000000FF00) |
            ((l >> 24) & 0x0000000000FF0000) |
            ((l >>  8) & 0x00000000FF000000) |
            ((l <<  8) & 0x000000FF00000000) |
            ((l << 24) & 0x0000FF0000000000) |
            ((l << 40) & 0x00FF000000000000) |
            ((l << 56) & 0xFF00000000000000) );
}

htonll :: #force_inline proc "c" (Value: c.ulonglong) -> c.ulonglong { return _WS2_32_WINSOCK_SWAP_LONGLONG(Value); }
ntohll :: #force_inline proc "c" (Value: c.ulonglong) -> c.ulonglong { return _WS2_32_WINSOCK_SWAP_LONGLONG(Value); }

WSASetService               :: WSASetServiceW;
WSAEnumNameSpaceProvidersEx :: WSAEnumNameSpaceProvidersExW;
WSAEnumNameSpaceProviders   :: WSAEnumNameSpaceProvidersW;
WSAGetServiceClassInfo      :: WSAGetServiceClassInfoW;
WSAInstallServiceClass      :: WSAInstallServiceClassW;
WSALookupServiceBegin       :: WSALookupServiceBeginW;
WSASocket                   :: WSASocketW;
WSAAddressToString          :: WSAAddressToStringW;
WSAStringToAddress          :: WSAStringToAddressW;
GetHostName                 :: GetHostNameW;
WSAConnectByName            :: WSAConnectByNameW;
WSADuplicateSocket          :: WSADuplicateSocketW;
WSAEnumProtocols            :: WSAEnumProtocolsW;

@(default_calling_convention = "stdcall")
foreign winsock2 {
    htonf  :: proc(Value: c.float)     -> c.float     ---
    htond  :: proc(Value: c.double)    -> c.ulonglong ---
    nothd  :: proc(Value: c.ulonglong) -> c.double    ---

    GetHostNameW                 :: proc(name: LPCWSTR, namelen: c.int)                                                                                                                                                                                                     -> c.int    ---
    WSAAccept                    :: proc(s: SOCKET, addr: ^sockaddr, addrlen: ^c.int, lpfnCondition: CONDITIONPROC, dwCallbackData: ^DWORD)                                                                                                                                 -> SOCKET   ---
    WSACloseEvent                :: proc(hEvent: WSAEVENT)                                                                                                                                                                                                                  -> bool     ---
    WSAConnect                   :: proc(s: SOCKET, name: ^sockaddr, namelen: c.int, lpCallerData: ^WSABUF, lpCalleeData: ^WSABUF, lpSQOS: ^QOS, lpGQOS: ^QOS)                                                                                                              -> c.int    ---
    WSAConnectByNameW            :: proc(s: SOCKET, nodename: ^WSTR, servicename: ^WSTR, LocalAddressLength: ^DWORD, LocalAddress: ^SOCKADDR, RemoteAddressLength: ^DWORD, RemoteAddress: ^SOCKADDR, timeout: ^timeval, Reserved: ^OVERLAPPED)                              -> bool     ---
    WSAConnectByList             :: proc(s: SOCKET, SocketAddress: ^SOCKET_ADDRESS_LIST, LocalAddressLength: ^DWORD, LocalAddress: ^SOCKADDR, RemoteAddressLength: ^DWORD, RemoteAddress: ^SOCKADDR, timeout: ^timeval, Reserved: ^OVERLAPPED)                              -> bool     ---
    WSACreateEvent               :: proc()                                                                                                                                                                                                                                  -> WSAEVENT ---
    WSADuplicateSocketW          :: proc(s: SOCKET, dwProcessId: DWORD, lpProtocolInfo: ^WSAPROTOCOL_INFO)                                                                                                                                                                  -> c.int    ---
    WSAEnumNetworkEvents         :: proc(s: SOCKET, hEventObject: WSAEVENT, lpNetworkEvents: WSANETWORKEVENTS)                                                                                                                                                              -> c.int    ---
    WSAEnumProtocolsW            :: proc(lpiProtocols: ^c.int, lpProtocolBuffer: ^WSAPROTOCOL_INFO, lpdwBufferLength: ^DWORD)                                                                                                                                               -> c.int    ---
    WSAEventSelect               :: proc(s: SOCKET, hEventObject: WSAEVENT, lNetworkEvents: c.long)                                                                                                                                                                         -> c.int    ---
    WSAGetOverlappedResult       :: proc(s: SOCKET, lpOverlapped: ^WSAOVERLAPPED, lpcbTransfer: ^DWORD, fWait: bool, lpdwFlags: ^DWORD)                                                                                                                                     -> bool     ---
    WSAGetQOSByName              :: proc(s: SOCKET, lpQOSName: ^WSABUF, lpQOS: ^QOS)                                                                                                                                                                                        -> bool     ---
    WSAHtonl                     :: proc(s: SOCKET, hostlong: u_long, ipnetlong: ^u_long)                                                                                                                                                                                   -> c.int    ---

    WSAHtons                     :: proc(s: SOCKET, hostshort: u_short, lpnetshort: ^u_short)                                                                                                                                                                               -> c.int  ---
    WSANtohl                     :: proc(s: SOCKET, netlong: u_long, lphostlong: ^u_long)                                                                                                                                                                                   -> c.int  ---
    WSANtohs                     :: proc(s: SOCKET, netshort: u_short, lphostshort: ^u_short)                                                                                                                                                                               -> c.int  ---
    WSAIoctl                     :: proc(s: SOCKET, dwIoControlCode: DWORD, lpvInBuffer: rawptr, cbInBuffer: DWORD, lpvOutBuffer: rawptr, cbOutBuffer: DWORD, lpcbBytesReturned: ^DWORD, lpOverlapped: WSAOVERLAPPED, lpCompletionRoutine: ^WSAOVERLAPPED_COMPLETION_ROUTINE) -> c.int  ---
    WSAJoinLeaf                  :: proc(s: SOCKET, name: ^sockaddr, namelen: c.int, lpCallerData: ^WSABUF, lpCalleeData: ^WSABUF, lpSQOS: ^QOS, lpGQOS: ^QOS, dwFlags: DWORD)                                                                                              -> SOCKET ---
    WSARecvDisconnect            :: proc(s: SOCKET, lpInboundDisconnectData: ^WSABUF)                                                                                                                                                                                       -> c.int  ---
    WSARecvFrom                  :: proc(s: SOCKET, lpBuffers: ^WSABUF, dwBufferCount: DWORD, lpNumberOfBytesRecvd: ^DWORD, lpFlags: ^DWORD, lpFrom: ^sockaddr, lpFromlen: ^c.int, lpOverlapped: ^WSAOVERLAPPED, lpCompletionRoutine: ^WSAOVERLAPPED_COMPLETION_ROUTINE)    -> c.int  ---
    WSAResetEvent                :: proc(hEvent: WSAEVENT)                                                                                                                                                                                                                  -> bool   ---
    WSASendMsg                   :: proc(Handle: SOCKET, lpMsg: ^WSAMSG, dwFlags: DWORD, lpNumberOfBytesSent: ^DWORD, lpOverlapped: WSAOVERLAPPED, lpCompletion: ^WSAOVERLAPPED_COMPLETION_ROUTINE)                                                                         -> c.int  ---
    WSASendDisconnect            :: proc(s: SOCKET, lpOutboundDisconnectData: ^WSABUF)                                                                                                                                                                                      -> c.int  ---
    WSASendTo                    :: proc(s: SOCKET, lpBuffers: ^WSABUF, dwBufferCount: DWORD, lpNumberOfBytesSent: ^DWORD, dwFlags: DWORD, lpTo: ^sockaddr, iTolen: c.int, lpOverlapped: ^WSAOVERLAPPED, lpCompletionRoutine: ^WSAOVERLAPPED_COMPLETION_ROUTINE)            -> c.int  ---
    WSASetEvent                  :: proc(hEvent: WSAEVENT)                                                                                                                                                                                                                  -> bool   ---
    WSASocketW                   :: proc(af: c.int, type: c.int, protocol: c.int, lpProtocolInfo: ^WSAPROTOCOL_INFO, g: GROUP, dwFlags: DWORD)                                                                                                                              -> SOCKET ---

    // Redeclarations that clash with sys/windows/ws_32:
    // WSASend :: proc(s: SOCKET, lpBuffers: ^WSABUF, dwBufferCount: DWORD, lpNumberOfBytesSent: ^DWORD, dwFlags: DWORD, lpOverlapped: WSAOVERLAPPED, lpCompletionRoutine: ^WSAOVERLAPPED_COMPLETION_ROUTINE) -> c.int  ---

    WSAAddressToStringW          :: proc(lpsaAddress: ^SOCKADDR, dwAddressLength: DWORD, lpProtocolInfo: ^WSAPROTOCOL_INFO, lpszAddressString: WSTR, lpdwAddressStringLength: ^DWORD)                                    -> c.int ---
    WSAStringToAddressW          :: proc(AddressString: WSTR, AddressFamily: c.int, lpProtocolInfo: WSAPROTOCOL_INFO, lpAddress: ^SOCKADDR, lpAddressLength: ^c.int)                                                     -> c.int ---
    WSALookupServiceBeginW       :: proc(lpqsRestrictions: WSAQUERYSET, dwControlFlags: DWORD, lphLookup: ^HANDLE)                                                                                                       -> c.int ---
    WSALookupServiceNextW        :: proc(hLookup: HANDLE, dwControlFlags: DWORD, lpdwBufferLength: ^DWORD, lpqsResults: ^WSAQUERYSET)                                                                                    -> c.int ---
    WSANSPIoctl                  :: proc(hLookup: HANDLE, dwControlCode: DWORD, lpvInBuffer: rawptr, cbInBuffer: DWORD, lpvOutBuffer: rawptr, cbOutBuffer: DWORD, lpcbBytesReturned: ^DWORD, lpCompletion: ^WSACOMPLETION) -> c.int ---
    WSALookupServiceEnd          :: proc(hLookup: HANDLE)                                                                                                                                                                -> c.int ---
    WSAInstallServiceClassW      :: proc(lpServiceClassInfo: WSASERVICECLASSINFO)                                                                                                                                        -> c.int ---
    WSAGetServiceClassInfoW      :: proc(lpProviderId: ^GUID, lpServiceClassId: ^GUID, lpdwBufSize: ^DWORD, lpServiceClassInfo: WSASERVICECLASSINFO)                                                                     -> c.int ---
    WSAEnumNameSpaceProvidersW   :: proc(lpdwBufferLength: ^DWORD, lpnspBuffer: ^WSANAMESPACE_INFO)                                                                                                                      -> c.int ---
    WSAEnumNameSpaceProvidersExW :: proc(lpdwBufferLength: ^DWORD, lpnspBuffer: ^WSANAMESPACE_INFO)                                                                                                                      -> c.int ---
    WSASetServiceW               :: proc(lpqsRegInfo: WSAQUERYSET, essoperation: WSAESETSERVICEOP, dwControlFlags: DWORD)                                                                                                -> c.int ---
    WSAProviderConfigChange      :: proc(lpNotificationHandle: ^HANDLE, lpOverlapped: ^WSAOVERLAPPED, lpCompletionRoutine: WSAOVERLAPPED_COMPLETION_ROUTINE)                                                             -> c.int ---
    WSAPoll                      :: proc(fdArray: ^WSAPOLLFD, fds: c.ulong, timeout: c.int)                                                                                                                              -> c.int ---
}
