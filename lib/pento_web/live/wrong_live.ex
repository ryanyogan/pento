defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {
      :ok,
      assign(
        socket,
        score: 0,
        message: "Guess a number.",
        number: generate_number()
      )
    }
  end

  @impl true
  def render(assigns) do
    ~L"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <h2>
      <%= for n <- 1..10 do %>
        <a href="#" phx-click="guess" phx-value-number="<%= n %>"><%= n %></a>
      <% end %>
    </h2>
    """
  end

  @impl true
  def handle_event("guess", %{"number" => guess}, socket = %{assigns: %{number: number}}) do
    handle_guess(guess, to_string(number), socket)
  end

  defp handle_guess(guess, number, socket) when guess == number do
    message = "Your guessed rite!: #{guess}."
    score = socket.assigns.score + 1

    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        number: generate_number()
      )
    }
  end

  defp handle_guess(guess, _number, socket) do
    message = "Your guess: #{guess}. Wrong. Guess again."
    score = socket.assigns.score - 1

    {
      :noreply,
      assign(
        socket,
        message: message,
        score: score,
        number: generate_number()
      )
    }
  end

  defp generate_number do
    1..10 |> Enum.random()
  end
end
