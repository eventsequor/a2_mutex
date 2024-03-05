defmodule Main do
  def start_supervisor do
    # This create the supper visor
    children = [
      {Mutex, name: MyMutexConnect, meta: "some_data"}
    ]

    {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)
  end

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

  @chars "ABCDEFGHIJKLMNOPQRSTUVWXYZ" |> String.split("")

  def random_string do
    Enum.reduce(1..Enum.random(6..10), [], fn _i, acc ->
      [Enum.random(@chars) | acc]
    end)
    |> Enum.to_list()
  end

  def create_random_message(room) do
    join_message_in_one_room = fn room_list ->
      room_list |> Enum.map(fn room -> room.message end)
    end

    generate_message = fn ->
      room.participans
      |> Enum.map(fn participan ->
        Task.async(fn ->
          Process.sleep(Enum.random(1..10))
          Room.add_message(room, participan, "Message #{random_string()}")
        end)
      end)
      |> Task.await_many()
    end

    Enum.map(1..Enum.random(2..5), fn _ -> generate_message.() |> join_message_in_one_room.() end)
    |> Enum.concat()
  end

  def disconnect_all_participans(room) do
    if Enum.count(room.participans) == 0 do
      room
    else
      disconnect_all_participans(Room.disconnect_participan(room, Enum.random(room.participans)))
    end
  end

  def main do
    start_supervisor()

    room = Room.new_room("Room-01")
    id_participan_list = 1..2

    IO.puts("=================================")
    IO.puts("====  Creating rooms by user  ===")
    IO.puts("=================================")
    # Here each use create a room where is going to be append
    rooms_list = create_rooms_by_participan(id_participan_list)

    IO.puts("=================================")
    IO.puts("=====  Rooms by participan  =====")
    IO.puts("=================================")
    IO.inspect(rooms_list)

    # Join participans
    room =
      Room.set_participans_list(room, rooms_list |> Enum.map(fn room -> room.participans end))

    IO.puts("=================================")
    IO.puts("=====  Adding random message ====")
    IO.puts("=================================")

    # Join messages
    room = Room.set_message_list(room, create_random_message(room))

    IO.puts("=============================================")
    IO.puts("=====  Room with message and participans ====")
    IO.puts("=============================================")
    IO.inspect(room)

    IO.puts("======================================")
    IO.puts("=====  Disconnect all participans ====")
    IO.puts("======================================")
    IO.inspect disconnect_all_participans(room)
  end
end
