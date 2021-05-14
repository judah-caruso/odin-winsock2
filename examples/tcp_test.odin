package main

import "core:fmt"
import ws "../"

// Simple TCP client that waits for a connection and echos back the message.
main :: proc() {
    using ws;

    wsa_data: WSADATA;
    if WSAStartup(WINSOCK_VERSION, &wsa_data) != 0 {
        fmt.println("[TCP] Unable to initialize Winsock!");
        return;
    }

    defer {
        fmt.println("[TCP] Cleaning up Winsock");
        WSACleanup();
    }

    server: sockaddr_in;
    server.sin_family = AF_INET;
    server.sin_port = htons(7890);
    server.sin_addr.s_addr = htonl(INADDR_ANY);

    sock := socket(AF_INET, SOCK_STREAM, 0);
    if sock == INVALID_SOCKET {
        fmt.printf("[TCP] Socket failed: %d\n", WSAGetLastError());
        return;
    }

    defer closesocket(sock);

    if bind(sock, cast(^sockaddr)&server, size_of(sockaddr_in)) == SOCKET_ERROR {
        fmt.printf("[TCP] Bind failed: %d\n", WSAGetLastError());
        return;
    }

    if listen(sock, SOMAXCONN) == SOCKET_ERROR {
        fmt.printf("[TCP] listen failed: %d\n", WSAGetLastError());
        return;
    }

    fmt.printf("[TCP] Listening at 127.0.0.1:%d\n", ntohs(server.sin_port));

    client_socket := accept(sock, nil, nil);
    if client_socket == INVALID_SOCKET {
        fmt.printf("[TCP] accept failed: %d\n", WSAGetLastError());
        return;
    }

    defer closesocket(client_socket);

    buffer_length :: 1024;
    response_buffer: [buffer_length]u8;

    for result := 1; result > 0; {
        result = auto_cast recv(client_socket, &response_buffer, buffer_length, 0);

        if result > 0 {
            fmt.printf("[TCP] Request:\n%s\n", string(response_buffer[:result]));
            if send(client_socket, &response_buffer, auto_cast result, 0) == SOCKET_ERROR {
                fmt.printf("[TCP] send failed: %d\n", WSAGetLastError());
                break;
            }
        }
        else {
            fmt.printf("[TCP] recv failed: %d\n", WSAGetLastError());
            break;
        }
    }
}
