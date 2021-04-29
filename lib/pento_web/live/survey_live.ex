defmodule PentoWeb.SurveyLive do
  use PentoWeb, :live_view
  alias Pento.{Catalog, Accounts, Survey}
  alias PentoWeb.Endpoint

  @survey_results_topic "survey_results"

  @impl true
  def mount(_params, %{"user_token" => token}, socket) do
    {:ok,
     socket
     |> assign_user(token)
     |> assign_demographic()
     |> assign_products()}
  end

  @impl true
  def handle_info({:created_demographic, demographic}, socket) do
    {:noreply, socket |> handle_demographic_created(demographic)}
  end

  @impl true
  def handle_info({:created_rating, updated_product, product_index}, socket) do
    {:noreply, socket |> handle_rating_created(updated_product, product_index)}
  end

  defp assign_user(socket, token) do
    assign_new(socket, :current_user, fn ->
      Accounts.get_user_by_session_token(token)
    end)
  end

  defp assign_demographic(%{assigns: %{current_user: current_user}} = socket) do
    socket
    |> assign(:demographic, Survey.get_demographic_by_user(current_user))
  end

  defp assign_products(%{assigns: %{current_user: current_user}} = socket) do
    socket
    |> assign(:products, list_products(current_user))
  end

  defp handle_demographic_created(socket, demographic) do
    socket
    |> put_flash(:info, "Demographic created successfully")
    |> assign(:demographic, demographic)
  end

  defp handle_rating_created(
         %{assigns: %{products: products}} = socket,
         updated_product,
         product_index
       ) do
    Endpoint.broadcast(@survey_results_topic, "rating_created", %{})

    socket
    |> put_flash(:info, "Rating submitted successfully")
    |> assign(
      :products,
      List.replace_at(products, product_index, updated_product)
    )
  end

  defp list_products(user) do
    Catalog.list_products_with_user_ratings(user)
  end
end
