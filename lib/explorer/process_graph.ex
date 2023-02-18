defmodule Explorer.ProcessGraph do
  require Logger

  def get_running_applications() do
    :application.info()
    |> Keyword.get(:running)
    |> Enum.filter(fn {_name, pid} -> pid != :undefined end)
  end

  def find_application_pid(application) when is_atom(application) do
    get_running_applications()
    |> Enum.find(fn {name, _pid} -> name == application end)
  end

  def build_process_tree_for_application({application, pid}) when is_atom(application) do
    pi = Process.info(pid)

    children =
      pi[:links]
      |> Enum.map(fn linked_pid -> build_process_tree_for_link(linked_pid, %{pid => true}) end)

    %{pid: inspect(pid), children: children}
  end

  def build_process_tree_for_link(port, parent_pids) when is_port(port) do
    pi = Port.info(port)

    children =
      pi[:links]
      |> Enum.filter(fn link_pid ->
        Map.get(parent_pids, link_pid)
        |> is_nil()
      end)
      |> Enum.map(fn link_pid ->
        build_process_tree_for_link(link_pid, parent_pids |> Map.put(port, true))
      end)

    %{port: inspect(port), children: children}
  end

  def build_process_tree_for_link(pid, parent_pids) when is_pid(pid) do
    pi = Process.info(pid)

    children =
      pi[:links]
      |> Enum.filter(fn link_pid ->
        Map.get(parent_pids, link_pid)
        |> is_nil()
      end)
      |> Enum.map(fn link_pid ->
        build_process_tree_for_link(link_pid, parent_pids |> Map.put(pid, true))
      end)

    %{pid: inspect(pid), children: children}
  end
end
