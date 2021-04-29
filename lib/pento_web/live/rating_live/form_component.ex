defmodule PentoWeb.RatingLive.FormComponent do
  use PentoWeb, :live_component
  alias Pento.Survey
  alias Pento.Survey.Rating

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_ratings()
     |> assign_changeset()}
  end

  @impl true
  def handle_event("validate", %{"rating" => rating_params}, socket) do
    {:noreply, socket |> validate_rating(rating_params)}
  end

  @impl true
  def handle_event("save", %{"rating" => rating_params}, socket) do
    {:noreply, socket |> save_rating(rating_params)}
  end

  defp assign_ratings(%{assigns: %{user: user, product: product}} = socket) do
    socket
    |> assign(:rating, %Rating{user_id: user.id, product_id: product.id})
  end

  defp assign_changeset(%{assigns: %{rating: rating}} = socket) do
    socket
    |> assign(:changeset, Survey.change_rating(rating))
  end

  defp validate_rating(socket, rating_params) do
    changeset =
      socket.assigns.rating
      |> Survey.change_rating(rating_params)
      |> Map.put(:action, :validate)

    socket |> assign(:changeset, changeset)
  end

  defp save_rating(
         %{assigns: %{product_index: product_index, product: product}} = socket,
         rating_params
       ) do
    case Survey.create_rating(rating_params) do
      {:ok, rating} ->
        product = %{product | ratings: [rating]}
        send(self(), {:created_rating, product, product_index})
        socket

      {:error, %Ecto.Changeset{} = changeset} ->
        socket |> assign(:changeset, changeset)
    end
  end
end
