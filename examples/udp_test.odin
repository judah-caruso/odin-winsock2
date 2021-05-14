package main

import "core:fmt"
import ws "../"

// Simple UDP client to echo any messages it receives back to the sender.
main :: proc() {
    using ws;

    wsa_data: WSADATA;
    if WSAStartup(WINSOCK_VERSION, &wsa_data) != 0 {
        fmt.println("[UDP] Unable to initialize Winsock!");
        return;
    }

    defer {
        fmt.println("[UDP] Cleaning up Winsock");
        WSACleanup();
    }

    server: sockaddr_in;
    server.sin_family = AF_INET;
    server.sin_port = htons(7890);
    server.sin_addr.s_addr = htonl(INADDR_ANY);

    sock := socket(AF_INET, SOCK_DGRAM, 0);
    if sock == INVALID_SOCKET {
        fmt.printf("[UDP] Socket failed: %d\n", WSAGetLastError());
        return;
    }

    defer closesocket(sock);

    if bind(sock, cast(^sockaddr)&server, size_of(sockaddr_in)) == SOCKET_ERROR {
        fmt.printf("[UDP] Bind failed: %d\n", WSAGetLastError());
        return;
    }

    fmt.printf("[UDP] Listening at 127.0.0.1:%d\n", ntohs(server.sin_port));

    buffer_length :: 1024;
    response_buffer: [buffer_length]u8;

    for {
        for i := 0; i < buffer_length; i += 1 do response_buffer[i] = 0;

        client: sockaddr_in;
        client_size := size_of(sockaddr_in);

        received := recvfrom(sock, &response_buffer, buffer_length, 0, cast(^sockaddr)&client, auto_cast &client_size);
        if received < 0 {
            fmt.printf("[UDP] Failed recv: %d", WSAGetLastError());
            return;
        }

        sent := sendto(sock, &response_buffer, received, 0, cast(^sockaddr)&client, auto_cast client_size);
        if sent < 0 {
            fmt.printf("[UDP] Failed sendto: %d\n", WSAGetLastError());
            return;
        }

        fmt.printf("[UDP] Request:\n%s", string(response_buffer[:sent]));
        break;
    }
}

