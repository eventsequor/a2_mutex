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
end
