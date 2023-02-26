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
    application_controller_pid = Process.whereis(:application_controller)

    children =
      pi[:links]
      |> Enum.filter(fn linked_pid -> linked_pid != application_controller_pid end)
      |> Enum.map(fn linked_pid -> build_process_tree_for_link(linked_pid, pid) end)

    if is_nil(pi[:registered_name]) do
      %{pid: inspect(pid), children: children}
    else
      %{name: inspect(pi[:registered_name]), pid: inspect(pid), children: children}
    end
  end

  def build_process_tree_for_link(port, parent_pid) when is_port(port) do
    pi = Port.info(port)

    children =
      pi[:links]
      |> Enum.filter(fn link_pid ->
        link_pid != parent_pid
      end)
      |> Enum.map(fn link_pid ->
        build_process_tree_for_link(link_pid, port)
      end)

    %{port: inspect(port), children: children}
  end

  def build_process_tree_for_link(pid, parent_pid) when is_pid(pid) do
    pi = Process.info(pid)

    ancestors = pi[:dictionary][:"$ancestors"]

    valid_ancestory =
      if not is_nil(ancestors) do
        direct_ancestor = ancestors |> Enum.at(0)

        if is_atom(direct_ancestor) do
          Process.whereis(direct_ancestor) == parent_pid
        else
          direct_ancestor == parent_pid
        end
      else
        true
      end

    if valid_ancestory do
      build_node(pid, pi, parent_pid)
    else
      nil
    end
  end

  defp build_node(pid, pi, parent_pid) do
    children =
      pi[:links]
      |> Enum.filter(fn link_pid ->
        link_pid != parent_pid
      end)
      |> Enum.map(fn link_pid ->
        build_process_tree_for_link(link_pid, pid)
      end)
      |> Enum.filter(fn child -> not is_nil(child) end)

    if is_nil(pi[:registered_name]) do
      %{pid: inspect(pid), children: children}
    else
      %{name: pi[:registered_name], pid: inspect(pid), children: children}
    end
  end
end
