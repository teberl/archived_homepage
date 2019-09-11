defmodule PhxClient.Todos do
  @moduledoc """
  The Todos context.
  """

  import Ecto.Query, warn: false
  alias PhxClient.Repo

  alias PhxClient.Todos.Todo

  @doc """
  Returns the list of todos.

  ## Examples

      iex> list_todos()
      [%Todo{}, ...]

  """
  def list_todos(filter) do
    case filter do
      :SHOW_ACTIVE ->
        from t in Todo, where: t.completed == false, order_by: t.id

      :SHOW_COMPLETED ->
        from t in Todo, where: t.completed == true, order_by: t.id

      _ ->
        from t in Todo, order_by: t.id
    end
    |> Repo.all()
  end

  def list_todos do
    Repo.all(from t in Todo, order_by: t.id)
  end

  @doc """
  Gets a single todo.

  Raises `Ecto.NoResultsError` if the Todo does not exist.

  ## Examples

      iex> get_todo!(123)
      %Todo{}

      iex> get_todo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_todo!(id), do: Repo.get!(Todo, id)

  def get_todo_by!(clauses), do: Repo.get_by!(Todo, clauses)

  @doc """
  Creates a todo.

  ## Examples

      iex> create_todo(%{field: value})
      {:ok, %Todo{}}

      iex> create_todo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_todo(attrs \\ %{}) do
    %Todo{}
    |> Todo.changeset(attrs)
    |> Repo.insert()
    |> broadcast_change([:todo, :created])
  end

  @doc """
  Updates a todo.

  ## Examples

      iex> update_todo(todo, %{field: new_value})
      {:ok, %Todo{}}

      iex> update_todo(todo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_todo(%Todo{} = todo, attrs) do
    todo
    |> Todo.changeset(attrs)
    |> Repo.update()
    |> broadcast_change([:todo, :updated])
  end

  @doc """
  Deletes a Todo.

  ## Examples

      iex> delete_todo(todo)
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_todo(%Todo{} = todo) do
    Repo.delete(todo)
    |> broadcast_change([:todo, :deleted])
  end

  @doc """
    Deletes all completed Todos.

      ## Examples

      iex> delete_completed_todos()
      {:ok, %Todo{}}

      iex> delete_todo(todo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_completed_todos() do
    from(t in Todo, where: t.completed == true)
    |> Repo.delete_all()

    broadcast_change({:ok, list_todos()}, [:todo, :deleted_all])
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking todo changes.

  ## Examples

      iex> change_todo(todo)
      %Ecto.Changeset{source: %Todo{}}

  """
  def change_todo(%Todo{} = todo) do
    Todo.changeset(todo, %{})
  end

  # PubSub
  @topic inspect(__MODULE__)

  def subscribe do
    Phoenix.PubSub.subscribe(PhxClient.PubSub, @topic)
  end

  defp broadcast_change(todo_result, event) do
    case todo_result do
      {:ok, result} ->
        Phoenix.PubSub.broadcast(PhxClient.PubSub, @topic, {__MODULE__, event, result})
        {:ok, result}

      _ ->
        todo_result
    end
  end
end
