defmodule BeamSlidesWeb.SlideLive do
  use BeamSlidesWeb, :live_view

  @slides [
    %{id: 1, title: "Introduction to BEAM", content: "The Erlang Virtual Machine"},
    %{id: 2, title: "Key Features", content: "Concurrency, Distribution, Fault Tolerance"},
    # Add more slides as needed
  ]

  def mount(_params, _session, socket) do
    {:ok, assign(socket, current_slide: 1, slides: @slides)}
  end

  def handle_event("next_slide", _params, socket) do
    current = socket.assigns.current_slide
    max_slide = length(@slides)

    next_slide = if current < max_slide, do: current + 1, else: current
    {:noreply, assign(socket, current_slide: next_slide)}
  end

  def handle_event("prev_slide", _params, socket) do
    current = socket.assigns.current_slide

    prev_slide = if current > 1, do: current - 1, else: current
    {:noreply, assign(socket, current_slide: prev_slide)}
  end

  def render(assigns) do
    ~H"""
    <div class="slide-container">
        <div class="slide">
            <% current_slide = Enum.find(@slides, fn s -> s.id == @current_slide end) %>
            <h1><%= current_slide.title %></h1>
            <div class="content">
                <%= current_slide.content %>
            </div>
        </div>

        <div class="controls">
            <button phx-click="prev_slide">Previous</button>
            <span class="slide-number"><%= @current_slide %>/<%= length(@slides) %></span>
            <button phx-click="next_slide">Next</button>
        </div>
    </div>
    """
  end
end
