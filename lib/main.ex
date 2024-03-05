defmodule Main do
  defp connect_to_room(room, participan) do
    resource_id = {User, {:id, 1}}
    lock = Mutex.await(MyMutex, resource_id)
    Process.sleep(1000)
    room = Room.connect_participan(room, participan)
    Mutex.release(MyMutex, lock)
    room
  end

  defp add_message(room, participan, message) do
    resource_id = {User, {:id, 1}}
    lock = Mutex.await(MyMutex, resource_id)

    room = Room.add_message(room, participan, message)
    Mutex.release(MyMutex, lock)
    room
  end

  def main do
    # This create the supper visor
    children = [
      {Mutex, name: MyMutex, meta: "some_data"}
    ]

    {:ok, _pid} = Supervisor.start_link(children, strategy: :one_for_one)

    room = Room.new_room("Room-01")
    id_participan_list = 1..12

    rooms_list =
      Enum.map(id_participan_list, fn pos ->
        Task.async(fn ->
          # This sleep is for to test that every process are working independing of each other
          Process.sleep(Enum.random(1..10))
          connect_to_room(room, "Participan #{pos}")
        end)
      end)
      |> Task.await_many(60000)

    participans_list = rooms_list |> Enum.map(fn room -> room.participans end)

    IO.inspect(participans_list)
  end
end
