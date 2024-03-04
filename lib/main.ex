defmodule Main do
  def main do

    room01 = Room.new_room("Room01")
    connect_new_participan = fn participan ->
      lock = Mutex.await(MyMutex, room01)
      Room.connect_participan(room01, participan)
      Mutex.release(MyMutex, lock)
    end

    spawn(fn -> connect_new_participan.("Participan 1") end)

    IO.inspect(room01)
  end

    def test do
    room01 = Room.new_room("Room01")
    room01 = Room.connect_participan(room01, "Participan 1")
    room01 = Room.connect_participan(room01, "Participan 2")
    room01 = Room.connect_participan(room01, "Participan 2")
    room01 = Room.add_message(room01, "Participan 2", "First message")
    room01 = Room.disconnect_participan(room01, "Participan 2")
    IO.inspect(room01)
  end
end
