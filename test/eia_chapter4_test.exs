# defmodule TodoListTestOld do
#   use ExUnit.Case
#   doctest TodoList

#   test "it can convert a cleaned csv line into a todo entry" do
#     assert TodoList.convert_csv_line_to_entry("2018/12/19,Dentist") == %{
#              date: ~D[2018-12-19],
#              title: "Dentist"
#            }
#   end

#   test "it can convert a stream into the correct entry format" do
#     stream = TodoList.parse_csv("./data/todos.csv")

#     assert TodoList.parse_stream_into_list_of_entries(stream) == [
#              %{
#                date: ~D[2018-12-19],
#                title: "Dentist"
#              },
#              %{
#                date: ~D[2018-12-20],
#                title: "Shopping"
#              },
#              %{
#                date: ~D[2018-12-18],
#                title: "Movies"
#              }
#            ]
#   end

#   test "it can make an iteratively build todo list with CSV parsing" do
#     stream = TodoList.parse_csv("./data/todos.csv")

#     assert TodoList.new(TodoList.parse_stream_into_list_of_entries(stream)) ==
#              TodoList.new()
#              |> TodoList.add_entry(%{
#                date: ~D[2018-12-19],
#                title: "Dentist"
#              })
#              |> TodoList.add_entry(%{
#                date: ~D[2018-12-20],
#                title: "Shopping"
#              })
#              |> TodoList.add_entry(%{
#                date: ~D[2018-12-18],
#                title: "Movies"
#              })
#   end

#   test "that we can call .to_string on a todo list" do
#     assert TodoList.new() |> to_string() == "Todo Implementation"
#   end
# end
