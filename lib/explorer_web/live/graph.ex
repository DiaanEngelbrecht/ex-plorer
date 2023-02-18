defmodule ExplorerWeb.Live.Graph do
  use Phoenix.LiveView
  alias Explorer.ProcessGraph

  def mount(_params, _session, socket) do
    # if connected?(socket), do: Process.send_after(self(), :update, 30000)
    applications = ProcessGraph.get_running_applications()

    process_tree =
      ProcessGraph.find_application_pid(:explorer)
      |> ProcessGraph.build_process_tree_for_application()

    {:ok, assign(socket, applications: applications, process_tree: process_tree)}
  end
end
