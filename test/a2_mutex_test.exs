defmodule A2MutexTest do
  use ExUnit.Case
  doctest A2Mutex

  test "greets the world" do
    assert A2Mutex.hello() == :world
  end
end
