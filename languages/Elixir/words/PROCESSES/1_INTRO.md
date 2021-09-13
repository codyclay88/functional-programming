# Processes

Concurrency is at the heart of the Erlang (and therefore, Elixir) programming model. Processes are lightweight, meaning that creating them involves negligible time and memory overhead. Processes do not share memory, and instead communicate with each other through message passing. Messages are copied from the stack of the sending process to the heap of the receiving one. As processes execute concurrently in separate memory spaces, these memory spaces can be garbage collected separately, giving applications on the Erlang VM very predictable soft real-time properties, even under sustained heavy loads. Millions of processes can run concurrently on the same VM, each handling a standalone task. Processes fail when exceptions occur, but because there is no shared memory, failure can often be isolated as the processes were working on standalone tasks. This allows other processes working on unrelated or unaffected tasks to continue executing and the program as a whole to recover on its own.

An Elixir (and therefore Erlang) process is very similar to an OS process. It has its own address space, it can communicate with other processes through signals and messages, and the execution is controlled by a preemptive scheduler.

In Elixir, all code runs inside processes. Each process is isolated, which means that if one process fails then that failure is isolated to that process.

The most basic method for spawning new processes is the auto-imported `spawn/1` function, which takes a function as an argument and spawns a process to execute that function:

```elixir
iex(1)> spawn fn -> 1 + 1 end
#PID<0.107.0>
```

We can also spawn new process using the `spawn/3` function, which takes a module name, a function name, and a list of arguments:

```elixir
# procs.exs
defmodule Procs do
  def greeter(name) do
    IO.puts("Hello #{name}")
  end
end

iex(1)> spawn Procs, :greeter, ["world"]
Hello world
#PID<0.114.0>
```

NOTE: The combination of `Module, Function, Arguments` is so common in Elixir and Erlang code that is has an abbreviation: `MFA`. The `Module` is simply the name of the module, the `Function` is the name of the function as an atom, and the `Arguments` are represented as a list (which must match the arity of the function being called).

The return value of the `spawn` functions is a PID (process identifier). At this point, the process we spawned is very likely dead. The spawned process will execute the given function and exit after the function is done.

```elixir
iex(2)> pid = spawn fn -> 1 + 2 end
#PID<0.109.0>
iex(3)> Process.alive?(pid)
false
```

We can list all processes in a running system using the Elixir code function `:shell_default.i/0`

```zsh
iex(first@Codys-MBP)8> :shell_default.i()
Pid                   Initial Call                          Heap     Reds Msgs
Registered            Current Function                     Stack
<0.0.0>               erl_init:start/2                      1598     6024    0
init                  init:loop/1                              3
<0.1.0>               erts_code_purger:start/0               233        8    0
erts_code_purger      erts_code_purger:wait_for_request        2
<0.2.0>               erts_literal_area_collector:start      233        7    0
                      erts_literal_area_collector:msg_l        6
<0.3.0>               erts_dirty_process_signal_handler      233    19875    0
                      erts_dirty_process_signal_handler        3
<0.4.0>               erts_dirty_process_signal_handler      233        7    0
                      erts_dirty_process_signal_handler        3
<0.5.0>               erts_dirty_process_signal_handler      233        7    0
                      erts_dirty_process_signal_handler        3
<0.6.0>               prim_file:start/0                      233        6    0
                      prim_file:helper_loop/0                  2
<0.7.0>               socket_registry:start/0                233        8    0
socket_registry       socket_registry:loop/1                   5
<0.10.0>              erlang:apply/2                        6772   247576    0
erl_prim_loader       erl_prim_loader:loop/3                   7
<0.42.0>              logger_server:init/1                  1598      927    0
logger                gen_server:loop/7                       12
<0.44.0>              erlang:apply/2                        6772    65808    0
application_controlle gen_server:loop/7                        8
<0.46.0>              application_master:init/4              376       40    0
                      application_master:main_loop/2           8
<0.47.0>              application_master:start_it/4          233      467    0
                      application_master:loop_it/4             7
......
```

Each process in this output gets two lines of information. The first two ines of the printout are the headers telling you what the information means. As you can see you get the Process ID (Pid) and the name of the process if any
