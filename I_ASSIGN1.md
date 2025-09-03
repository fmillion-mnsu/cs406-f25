# Individual Assignment 1 - TCP Socket Communication

In this assignment you will write a simple server and client that uses the TCP protocol. You can use any programming language you wish.

You will design a very simple protocol that includes:

* a server "welcome" message - some way for the server to tell the client it's received its connection and that it is ready to receive commands. This can also be used by the client to verify it's connecting to a supported server.
* two or more "commands" - operations that the client can issue to the server, along with their responses
* an "exit" or "quit" command that tells the server to close the connection

Your server program must do the following:

* Listen for TCP connections on a port greater than 1024 and less than 49152
* Accept connections by printing a welcome message or indicator over the socket
* Respond to at least two commands from the client by doing something - for example, printing a message on the server console, responding with the current date and time, etc.
* Respond to a "quit" or similar command by closing the connection

Your client program must do the following:

* Connect to the server program by providing an IP address and port to the client
* The client must connect to the server, receive the welcome message and issue one command and print its response. It should then issue the "quit" or "exit" command to close the connection.
* The client must then connect *again* to the server, receive the welcome message and issue the *second* command. It should then issue the "quit" or "exit" command.
    > If you wrote more than two commands, you can "bunch up" commands - each connection can run more than one command, but you must connect two distinct times.
* Print the operations occurring and the actual responses from the server

## Submission

Your submission must include:

* A short document describing your protocol - the messages you chose and the responses. Think of this as similar to a Web API's documentation.
* Source code for your client and server applications

This assignment is due **September 12th at 11:59 PM**.

## Scoring Rubric

This assignment is worth 100 points. Points are assigned as follows:

| Item | Points | Penalties |
|-|-|-|
| Provide a written document describing the protocol you devised for your application | 35 | Point loss for missing elements from the protocol document. 0 if document missing. |
| Successfully implement a client and server application implementing the defined protocol. | 65 | Point loss for non-working code, incorrect implementation or other significant errors.
