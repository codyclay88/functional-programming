# Nodes

A `node` is a running instance of the Erlang VM. When starting an `iex` session, you are creating a `node`.

Nodes, by default, are isolated from each other, but Erlang (and, by proxy, Elixir) have many facilities for communicating between them. You don't have to write any infrastructure code to communicate between them, it is a built-in feature.

The `Node` module contains many functions that we will be using in this post:

- `Node.self/0` returns an atom representing the name of the current node (this is the same as invoking the built-in `node/0` function) (if the node is not "alive" (more on this later) will return `:nonode@nohost`)
- `Node.connect/1` allows you to connect to another local or remote Node
- `Node.alive?/0` tells you whether or not the local node is "alive" (meaning whether or not the node can be part of a distributed system)
- `Node.get_cookie/0` returns the value of the cookie required for connecting to other nodes (more on this later)
- `Node.list/0` returns a list of all visible nodes in the system, excluding the local node.

You can connect multiple Erlang VMs together using the `Node.connect/1` function.

In order for two nodes to connect to each other, they both must have two things:

1. a name
2. a shared cookie

The name allows the two nodes to identify each other.
The shared cookie provides a very basic level of security.

## Connecting to local nodes

Now if we were to just whip up an IEx session by simply using the `iex` command, we will not be able to connect to any other nodes.
This is because we must specify the name for our node when creating the IEx session.

```elixir
$ iex
Erlang/OTP 24 [erts-12.0.3] [source] [64-bit] [smp:16:16] [ds:16:16:10] [async-threads:1] [jit] [dtrace]

Interactive Elixir (1.12.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(1)> Node.alive?
false
iex(2)> Node.self
:nonode@nohost
iex(3)> Node.get_cookie
:nocookie
```

As shown in the output above, starting an IEx session without specifying a name, the node is considered "dead" (or at least not "alive"), meaning that it cannot connect to other nodes. Note that the name of the node (as indicated by the value returned from `Node.self`) is `:nonode@nohost` and the cookie is `:nocookie`. This node is a lone wolf. An island. It's kind of sad actually.

Let's kill this node (too soon) and start a new one, but this time let's give our node a name.

```elixir
$ iex --sname first_node
Erlang/OTP 24 [erts-12.0.3] [source] [64-bit] [smp:16:16] [ds:16:16:10] [async-threads:1] [jit] [dtrace]

Interactive Elixir (1.12.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(first_node@Codys-MBP)1> Node.alive?
true
iex(first_node@Codys-MBP)2> Node.self
:"first_node@Codys-MBP"
iex(first_node@Codys-MBP)3> Node.get_cookie
:NESPJGXVMYBEVJMCBECR
```

When starting this IEx session we used the `--sname` flag, which allows us to specify a "short name" for our new node, in this case "first_node". A couple things happened after setting the name:

1. Calling `Node.alive?/0` now returns true. Sweet!
2. Calling `Node.self/0` gives us the name that we specified when creating the session followed by `@Codys-MBP`. This is actually the "long name" of our node, which is the "short name" we specified followed by the name of our computer.
3. A call to `Node.get_cookie/0` returns a funky (cole medina) looking atom.
4. IEx now shows the name of our node with each prompt.

Okay cool beans! Let's go ahead and start up another IEx session in another terminal prompt, this time with the command `iex --sname second_node`.

```elixir
$ iex --sname second_node
Erlang/OTP 24 [erts-12.0.3] [source] [64-bit] [smp:16:16] [ds:16:16:10] [async-threads:1] [jit] [dtrace]

Interactive Elixir (1.12.2) - press Ctrl+C to exit (type h() ENTER for help)
iex(second_node@Codys-MBP)1> Node.alive?
true
iex(second_node@Codys-MBP)2> Node.self
:"second_node@Codys-MBP"
iex(second_node@Codys-MBP)3> Node.get_cookie
:NESPJGXVMYBEVJMCBECR
```

A couple things I want to note here:

1. I only specified the "short name" and yet the second portion of the "long name" (the portion after the `@` sign) for both nodes are the same. This is an indication to us that both nodes are running on the same host machine.
2. The value returned from `Node.get_cookie/0` is the same result that received on our "first_node", `:NESPJGXVMYBEVJMCBECR`.

At this point it is appropriate to ask, "Where is this cookie coming from?"

On my mac, this cookie is stored in a file located in my home directory called ".erlang.cookie".

```zsh
$ cat ~/.erlang.cookie
NESPJGXVMYBEVJMCBECR%
```

This cookie is used by default for all local nodes. (We can specify a different cookie using the `--cookie` flag when starting our IEx session, but more on that later.)

What this means is that because both of our nodes are running on our local machine, they both already share the same cookie.

You know what that means? It means we are now ready to connect our two nodes.

Drum roll please.

```elixir
iex(first_node@Codys-MBP)4> Node.connect(:"second_node@Codys-MBP")
true
iex(first_node@Codys-MBP)5> Node.list
[:"second_node@Codys-MBP"]
```

Well that was so easy that it was almost disappointing (if it wasn't so awesome). In this example we connected from our "first_node" to our "second_node" using the `Node.connect/1` function. The argument we passed to `Node.connect` is the "long name" of the node we are attempting to connect to (we cannot use the "short name" here, the "long name" is required) (if you don't know the name of the node you are attempting to connect to, you can find that out by invoking the `Node.self/0` function on the node you are trying to connect to, which will return the atom representation of the name).

After properly connecting to the other node we can now run `Node.list` on either node and we will see the name of the other node in our output list.

Freaking cool, right?

Well this was the simplest thing I've done in my software career, and it doesn't get much more complicated when connecting to remote nodes.

## Connecting to remote nodes

Remember earlier in this post when I said that two things are required to connect one node to another? Do you remember what they were?

- Name
- Cookie

Right. When connecting to local nodes we were able to take some shortcuts:

1. I only needed to specify a "short name" for each of my nodes
2. Both nodes shared the same default cookie from my ".erlang.cookie" file.

When connecting to remote nodes we have to be more explicit:

1. We cannot use a "short name" because we also need to know the IP Address (or DNS name) of the node we are trying to reach
2. We must specify a cookie that each node must share.

I am going to demonstrate this through two VMs that I spun up in DigitalOcean (the cheapest VMs they offered). Feel free to test this on two computers at your house or with a Raspberry Pi or something.

Now when creating the IEx session, we can specify the "long name" of our node using the `--name` flag and the cookie using the `--cookie` flag.

For first node:

```elixir
$ iex --name first@147.182.163.239 --cookie 123456
```

For second node:

```elixir
$ iex --name second@147.182.173.184 --cookie 123456
```

Notice that the cookie is the same for both nodes and the name of each node now includes the IP address of the host machine.

Now, this is kind of a silly example because in the real world both of these nodes would be on a private network behind a firewall or something and would use IP addresses relevant to their internal network. For this simple example I am using the globally accessible IP addresses (the machines have aleady been decommissioned, so don't get sly on me).

Now, because we know the names of both machines and both machines are sharing the same cookie, we can now attempt to connect them:

```elixir
iex(first@147.182.163.239)1> Node.connect(:"second@147.182.173.184")
true
iex(first@147.182.163.239)2> Node.list
[:"second@147.182.173.184"]
```

How cool is that? These nodes are now connected and can send messages back and forth to each other! And so easy!

## Sending messages between Nodes

In Erlang and Elixir, processes communicate by sending messages to each other rather than sharing memory. This provides true encapsulation. If process `a` wants to know something about process `b`, `a` cannot just reach into `b`s memory and figure it out, `a` has to send `b` a message and then wait for a response from `b`. In the same way, if process `a` needs to change the state of process `b`, `a` cannot simply reach into `b`s memory and muck things up, `a` has to send `b` a message to do so. Not only is this genuine encapsulation, this is also genuinely asynchronous -- `a` can send a message to `b` and then go along doing something else without waiting for a reply from `b` (if `b` responds at all). This is how all communication is done in Erlang and Elixir, even between processes on a single node, and because of that, the problem of communicating between nodes has already been solved as well.

So let's talk to a process on a remote node, shall we?

In order to send a message to a process on another node I have to "register" the process. This gives the process a name that can be addressed by other processes.

For this example, I just want to register the process that is running the IEx session on one of my nodes, and I can do this using the `Process.register/2` function:

```elixir
iex(second@Codys-MBP)4> Process.register(self(), :second)
```

If I didn't register the process then I would need to reference the other process by it's PID, which in many cases is transient -- if the process dies and is reborn it will have a new PID and I won't be able to talk to it -- but if the supervisor of the process gives the process a consistent name then other nodes can reliably refer to that process by its registered name.

And now from the other node I can send this process a message using the `send/2` function:

```elixir
iex(first@Codys-MBP)4> send({ :second, :"second@Codys-MBP"}, :hello)
:hello
```

I am using a version of the `send/2` function that takes a tuple as its first parameter that consists of the process identifier (in this case it's registered name) followed by the name of the node we are connecting to. The second parameter is the message we want to send.

Now I can read any messages on my receiving node by using the built-in `flush/0` function:

```elixir
iex(second@Codys-MBP)9> flush()
:hello
:ok
```

And we can see that the message was received on our second node.

I don't know about you, but I think this is pretty effing cool.
