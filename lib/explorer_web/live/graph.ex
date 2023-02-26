defmodule ExplorerWeb.Live.Graph do
  use Phoenix.LiveView
  alias Explorer.ProcessGraph
  
  require Logger

  def mount(_params, _session, socket) do
    # if connected?(socket), do: Process.send_after(self(), :update, 30000)

    application = :explorer
    applications = ProcessGraph.get_running_applications()

    process_tree =
      ProcessGraph.find_application_pid(application)
      |> ProcessGraph.build_process_tree_for_application()

    {:ok,
     assign(socket,
       process_tree: process_tree,
       application: application,
       applications: applications
     )}
  end

  def handle_event("change_app", %{"application" => app}, socket) do
    application = app |> String.to_atom()

    process_tree =
      ProcessGraph.find_application_pid(application)
      |> ProcessGraph.build_process_tree_for_application()


    Logger.info(inspect application)
    {:reply, %{}, assign(socket,
       process_tree: process_tree,
       application: application
     )}
  end
end
