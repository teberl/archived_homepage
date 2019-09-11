defmodule PhxClientWeb.TodosLive do
  use Phoenix.LiveView

  alias PhxClient.Todos
  alias PhxClientWeb.TodosView

  def render(assigns) do
    TodosView.render("todos.html", assigns)
  end

  def mount(_params, socket) do
    Todos.subscribe()

    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    filter = String.to_atom(params["filter"] || "SHOW_ALL")

    {:noreply,
     socket
     |> assign(filter: filter)
     |> assign(changeset: Todos.change_todo(%Todos.Todo{}))
     |> fetch()}
  end

  def handle_info({Todos, [:todo | _], _}, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_event("add", %{"todo" => todo}, socket) do
    result = Todos.create_todo(todo)

    case result do
      {:ok, _} ->
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(changeset: changeset)}
    end
  end

  def handle_event("toggle", id, socket) do
    todo = Todos.get_todo!(id)
    Todos.update_todo(todo, %{completed: !todo.completed})

    {:noreply, socket}
  end

  def handle_event("delete", id, socket) do
    Todos.get_todo!(id)
    |> Todos.delete_todo()

    {:noreply, socket}
  end

  def handle_event("clear_completed", _value, socket) do
    Todos.delete_completed_todos()

    {:noreply, socket}
  end

  def handle_event("focus", _, socket) do
    {:noreply, socket |> assign(changeset: Todos.change_todo(%Todos.Todo{}))}
  end

  defp fetch(socket) do
    filter = socket.assigns.filter || :SHOW_ALL
    todos = Todos.list_todos(filter)

    assign(socket,
      todos: todos,
      not_completed_count: not_completed_count(todos)
    )
  end

  defp not_completed_count(todos), do: Enum.count(todos, &(!&1.completed))
end
