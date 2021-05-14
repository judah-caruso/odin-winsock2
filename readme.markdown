# Winsock2 

Winsock2 bindings for the [Odin programming language](http://odin-lang.org/).

## Usage

Installation: 

```bash
cd Odin/shared
git clone https://github.com/judah-caruso/odin-winsock2 winsock2
```

Usage: 

```odin
import "shared:winsock2"
```

Simple TCP & UDP examples are in the `examples/` directory


## Notes

Some parts of these bindings are not fully functional. There's a Todo at the start of `winsock2.odin` describing what you may run into while using these. Another thing to watch out for is potential collisions with `sys/windows/ws2_32.odin`. Steps have been taken to make this less likely. PRs are welcome.