# This will not use for the current homework was one of the experiment before to arrive at the answer
defmodule RoomManager do
  use Agent
  def start do
    Agent.start(fn -> Room.new_room("Room01") end, name: __MODULE__)
  end

  def connect_participan(participan) do
    Agent.update(__MODULE__, fn room -> Room.connect_participan(room, participan) end)
  end

  def add_message(participan, message) do
    Agent.update(__MODULE__, fn room -> Room.add_message(room, participan, message) end)
  end

  def get_room() do
    Agent.get(__MODULE__, fn room -> room end)
  end

  def main do
    RoomManager.start()
    spawn(fn -> Task.async(fn -> RoomManager.connect_participan("Participan 21") end) end)

    Enum.map(1..1000, fn pos ->
      Task.async(fn ->
        Process.sleep(Enum.random(1..30))
        RoomManager.connect_participan("Participan #{pos}")
      end)
    end)
    |> Enum.each(fn task -> Task.await(task) end)

    IO.inspect(RoomManager.get_room())
  end
end
