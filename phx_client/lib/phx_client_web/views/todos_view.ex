defmodule PhxClientWeb.TodosView do
  use PhxClientWeb, :view
  use Phoenix.LiveView
  alias PhxClientWeb.Router.Helpers, as: Routes

  def get_not_completed_text(count) do
    items_text = if count == 1, do: "item", else: "items"

    if count == 0,
      do: "<strong>No</strong> #{items_text} left",
      else: "<strong>#{count}</strong> #{items_text} left"
  end

  def get_filter_link(socket, filter, isActive) do
    url = Routes.live_path(socket, PhxClientWeb.TodosLive, filter: filter)

    live_link(get_filter_text(filter),
      to: url,
      replace: true,
      class:
        "filter " <>
          cond do
            isActive -> "active"
            true -> ""
          end
    )
  end

  defp get_filter_text(filter) do
    case filter do
      :SHOW_ALL -> "All"
      :SHOW_ACTIVE -> "Active"
      :SHOW_COMPLETED -> " Completed"
    end
  end
end
