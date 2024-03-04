defmodule Main do
  def main do
    room01 = Room.new_room("Room01")
    resource_id = {User, {:id, 1}}

    connect_new_participan = fn participan ->
      lock = Mutexa.await(MyMain, resource_id)
      room01 = Room.connect_participan(room01, participan)
      Mutex.release(MyMain, lock)
    end

    spawn(fn -> connect_new_participan.("Participan 1") end)
    IO.inspect room01
  end

  def test do
    room01 = Room.new_room("Room01")
    get_room = fn -> room01 end
    room01 = Room.connect_participan(room01, "Participan 1")
    room01 = Room.connect_participan(room01, "Participan 2")
    room01 = Room.connect_participan(room01, "Participan 2")
    room01 = Room.add_message(room01, "Participan 2", "First message")
    room01 = Room.disconnect_participan(room01, "Participan 2")
    IO.inspect(get_room.())
  end

  def main2 do
    RoomManager.start()
    pid = spawn(fn -> Task.async(fn -> RoomManager.connect_participan("Participan 21") end) end)
    Enum.each(1..15, fn pos -> spawn(fn -> RoomManager.connect_participan("Participan #{pos}") end) end)


    IO.inspect RoomManager.get_room()
  end

end
