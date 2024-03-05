defmodule Room do
  defstruct [:name, :participans, :message]

  def connect_participan(room = %Room{}, participan) do
    resource_id = {User, {:id, 1}}
    lock = Mutex.await(MyMutexConnect, resource_id)

    unless Enum.member?(room.participans, participan) do
      IO.puts("Conecting participan: #{participan}")

      room = %Room{
        name: room.name,
        participans: room.participans ++ [participan | []],
        message: room.message
      }

      Mutex.release(MyMutexConnect, lock)
      room
    else
      IO.puts("INFO: The participan is already connected: #{participan}")
      Mutex.release(MyMutexConnect, lock)
      room
    end
  end

  def set_participans_list(room = %Room{}, participans_list) when is_list(participans_list) do
    %Room{
      name: room.name,
      participans: participans_list,
      message: room.message
    }
  end

  def set_message_list(room = %Room{}, message_list) when is_list(message_list) do
    %Room{
      name: room.name,
      participans: room.participans,
      message: message_list
    }
  end


  def disconnect_participan(room = %Room{}, participan) do
    if Enum.member?(room.participans, participan) do
      %Room{
        name: room.name,
        participans: List.delete(room.participans, participan),
        message: room.message
      }
    else
      IO.puts("ERROR: The participan was not connected in the room: #{participan}")
      room
    end
  end

  def add_message(room = %Room{}, participan, message) do
    resource_id = {User, {:id, 2}}
    lock = Mutex.await(MyMutexConnect, resource_id)
    Process.sleep(1)
    if Enum.member?(room.participans, participan) do
      IO.puts("INFO: The participan is connect and is append a message")

      message =
        "Name participan: #{participan}" <>
          " -:- TimeStamp: " <>
          to_string(:os.system_time(:millisecond)) <> " -:- Message: " <> message

      room = %Room{
        name: room.name,
        participans: room.participans,
        message: room.message ++ [message | []]
      }

      Mutex.release(MyMutexConnect, lock)
      room
    else
      IO.puts(
        "ERROR: The participan <#{participan}> should be connected to the room before to post"
      )

      Mutex.release(MyMutexConnect, lock)
      room
    end
  end

  def new_room(name_room) do
    %Room{name: name_room, participans: [], message: []}
  end

  defp test do
    room01 = Room.new_room("Room01")
    get_room = fn -> room01 end
    room01 = Room.connect_participan(room01, "Participan 1")
    room01 = Room.connect_participan(room01, "Participan 2")
    room01 = Room.connect_participan(room01, "Participan 2")
    room01 = Room.add_message(room01, "Participan 2", "First message")
    Room.disconnect_participan(room01, "Participan 2")
    IO.inspect(get_room.())
  end
end
