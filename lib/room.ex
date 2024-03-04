defmodule Room do
  defstruct [:name, :participans, :message]

  def connect_participan(room = %Room{}, participan) do
    unless Enum.member?(room.participans, participan) do
      IO.puts("Conecting participan: #{participan}")
      Process.sleep(Enum.random(1..30))
      %Room{
        name: room.name,
        participans: room.participans ++ [participan | []],
        message: room.message
      }
    else
      IO.puts("INFO: The participan is already connected: #{participan}")
      room
    end
  end

  def disconnect_participan(room = %Room{}, participan) do
    if Enum.member?(room.participans, participan) do
      %Room{name: room.name, participans: List.delete(room.participans, participan), message: room.message}
    else
      IO.puts("ERROR: The participan was not connected in the room: #{participan}")
      room
    end
  end

  def add_message(room = %Room{}, participan, message) do
    if Enum.member?(room.participans, participan) do
      IO.puts("INFO: The participan is connect and is append a message")
      message = "Name participan: #{participan}" <> " -:- TimeStamp: "  <> to_string(:os.system_time(:millisecond)) <>" -:- Message: " <> message
      %Room{name: room.name, participans: room.participans, message: room.message ++ [message | []]}
    else
      IO.puts "ERROR: The participan <#{participan}> should be connected to the room before to post"
      room
    end
  end

  def new_room(name_room) do
    %Room{name: name_room, participans: [], message: []}
  end
end
