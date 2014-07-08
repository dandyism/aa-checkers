# Checkers

This is a multiplayer implementation of checkers. It supports multiplayer hotseat, and it uses TCP sockets for multiplayer over LAN

## Usage

Run with `./checkers.rb`. To start a multiplayer LAN server, run `./checkers.rb -m`, and connect to it with `./checkers.rb -m <server address>`.

To make a move, select the man to move with a an X,Y coordinate at the prompt, then give a target square with another X,Y coordinate.
