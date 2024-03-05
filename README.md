# A2Mutex

@auto Eder Leandro Carbonero

## Prerequisites 

You have to get installed elixir and deployed the environment variables

## How to run the programa?

To run the program execute in the root of the project 

``` sh
iex -S mix
```
Then into the elixir console you can run the example project

``` elixir
Main.main
```

## How mutex work conclusions

There is a Supervisor that allow to lock a group o sentences, when this happend you are going to see that all process that try to execute that block of code are entry in a queue.

``` elixir
def create_rooms_by_participan(id_participan_list) do
    Enum.map(id_participan_list, fn pos ->
      Task.async(fn ->
        # This sleep is for to test that every process are working independing of each other
        Process.sleep(Enum.random(1..10))
        Room.connect_participan(Room.new_room("Room of participan #{pos}"), "Participan #{pos}")
      end)
    end)
    |> Enum.map(fn task -> Task.await(task) end)
  end
```

## Basic flow

Whe create a room, then when we create a group of Task that run independing but when each task arrive a the same to execute some mutex gruop o sentences then the system create a queue to answer every call