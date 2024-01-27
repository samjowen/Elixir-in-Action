defmodule TodoDbTest do
  use ExUnit.Case

  test "ensures that a DB record is always retrieved by the same worker" do
    assert :erlang.phash2("meowasa", 2) == 0
    assert :erlang.phash2("meoassaw", 2) == 0
    assert :erlang.phash2("measassow", 2) == 0
    assert :erlang.phash2("meodsddsw", 2) == 0
  end
end
