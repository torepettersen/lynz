defmodule LynxWeb.HomeLive do
  use LynxWeb, :live_view

  alias Lynx.Accounts.AnonymousUser
  alias Lynx.Accounts.User
  alias Lynx.ShortLinks.ShortLink
  alias AshPhoenix.Form

  @impl true
  def mount(_params, _session, socket) do
    form = Form.for_create(ShortLink, :create, actor: actor(socket)) |> to_form()

    socket
    |> assign(form: form)
    |> ok(layout: false)
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="bg-white">
      <header class="absolute inset-x-0 top-0 z-50">
        <.navbar current_user={@current_user} />
        <.mobile_navbar />
      </header>
      <.hero form={@form} />
    </div>
    """
  end

  @impl true
  def handle_event("shorten_url", %{"form" => params}, socket) do
    case Form.submit(socket.assigns.form, params: params) do
      {:ok, short_link} ->
        socket
        |> push_navigate(to: ~p"/short-link/#{short_link}")
        |> noreply()
    end
  end

  def navbar(assigns) do
    ~H"""
    <nav class="flex items-center justify-between p-6 lg:px-8" aria-label="Global">
      <div class="flex lg:flex-1">
        <a href="#" class="-m-1.5 p-1.5">
          <span class="sr-only">Your Company</span>
          <img
            class="h-8 w-auto"
            src="https://tailwindui.com/img/logos/mark.svg?color=indigo&shade=600"
            alt=""
          />
        </a>
      </div>
      <div class="flex lg:hidden">
        <button
          type="button"
          class="-m-2.5 inline-flex items-center justify-center rounded-md p-2.5 text-gray-700"
        >
          <span class="sr-only">Open main menu</span>
          <svg
            class="h-6 w-6"
            fill="none"
            viewBox="0 0 24 24"
            stroke-width="1.5"
            stroke="currentColor"
            aria-hidden="true"
            data-slot="icon"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M3.75 6.75h16.5M3.75 12h16.5m-16.5 5.25h16.5"
            />
          </svg>
        </button>
      </div>
      <div class="hidden lg:flex lg:gap-x-12">
        <a href="#" class="text-sm font-semibold leading-6 text-gray-900">Product</a>
        <a href="#" class="text-sm font-semibold leading-6 text-gray-900">Features</a>
        <a href="#" class="text-sm font-semibold leading-6 text-gray-900">Marketplace</a>
        <a href="#" class="text-sm font-semibold leading-6 text-gray-900">Company</a>
      </div>
      <div class="hidden lg:flex lg:flex-1 lg:justify-end lg:gap-x-6">
        <%= case @current_user do %>
          <% %User{} -> %>
            <.link navigate={~p"/sign-out"} class="text-sm font-semibold leading-6 text-gray-900">
              Sign out
            </.link>
          <% %AnonymousUser{} -> %>
            <.link navigate={~p"/register"} class="text-sm font-semibold leading-6 text-gray-900">
              Sign up
            </.link>
            <.link navigate={~p"/sign-in"} class="text-sm font-semibold leading-6 text-gray-900">
              Sign in
            </.link>
        <% end %>
      </div>
    </nav>
    """
  end

  defp mobile_navbar(assigns) do
    ~H"""
    <!-- Mobile menu, show/hide based on menu open state. -->
    <div class="lg:hidden" role="dialog" aria-modal="true">
      <!-- Background backdrop, show/hide based on slide-over state. -->
      <div class="fixed inset-0 z-50"></div>
      <div class="fixed inset-y-0 right-0 z-50 w-full overflow-y-auto bg-white px-6 py-6 sm:ring-gray-900/10 sm:max-w-sm sm:ring-1">
        <div class="flex items-center justify-between">
          <a href="#" class="-m-1.5 p-1.5">
            <span class="sr-only">Your Company</span>
            <img
              class="h-8 w-auto"
              src="https://tailwindui.com/img/logos/mark.svg?color=indigo&shade=600"
              alt=""
            />
          </a>
          <button type="button" class="-m-2.5 rounded-md p-2.5 text-gray-700">
            <span class="sr-only">Close menu</span>
            <svg
              class="h-6 w-6"
              fill="none"
              viewBox="0 0 24 24"
              stroke-width="1.5"
              stroke="currentColor"
              aria-hidden="true"
              data-slot="icon"
            >
              <path stroke-linecap="round" stroke-linejoin="round" d="M6 18 18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
        <div class="mt-6 flow-root">
          <div class="divide-gray-500/10 -my-6 divide-y">
            <div class="space-y-2 py-6">
              <a
                href="#"
                class="-mx-3 block rounded-lg px-3 py-2 text-base font-semibold leading-7 text-gray-900 hover:bg-gray-50"
              >
                Product
              </a>
              <a
                href="#"
                class="-mx-3 block rounded-lg px-3 py-2 text-base font-semibold leading-7 text-gray-900 hover:bg-gray-50"
              >
                Features
              </a>
              <a
                href="#"
                class="-mx-3 block rounded-lg px-3 py-2 text-base font-semibold leading-7 text-gray-900 hover:bg-gray-50"
              >
                Marketplace
              </a>
              <a
                href="#"
                class="-mx-3 block rounded-lg px-3 py-2 text-base font-semibold leading-7 text-gray-900 hover:bg-gray-50"
              >
                Company
              </a>
            </div>
            <div class="py-6">
              <a
                href="#"
                class="-mx-3 block rounded-lg px-3 py-2.5 text-base font-semibold leading-7 text-gray-900 hover:bg-gray-50"
              >
                Log in
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp hero(assigns) do
    ~H"""
    <div class="relative isolate px-6 pt-14 lg:px-8">
      <div
        class="absolute inset-x-0 -top-40 -z-10 transform-gpu overflow-hidden blur-3xl sm:-top-80"
        aria-hidden="true"
      >
        <div
          class="left-[calc(50%-11rem)] aspect-[1155/678] w-[36.125rem] rotate-[30deg] from-[#ff80b5] to-[#9089fc] relative -translate-x-1/2 bg-gradient-to-tr opacity-30 sm:left-[calc(50%-30rem)] sm:w-[72.1875rem]"
          style="clip-path: polygon(74.1% 44.1%, 100% 61.6%, 97.5% 26.9%, 85.5% 0.1%, 80.7% 2%, 72.5% 32.5%, 60.2% 62.4%, 52.4% 68.1%, 47.5% 58.3%, 45.2% 34.5%, 27.5% 76.7%, 0.1% 64.9%, 17.9% 100%, 27.6% 76.8%, 76.1% 97.7%, 74.1% 44.1%)"
        >
        </div>
      </div>
      <div class="mx-auto max-w-2xl py-32 sm:py-48 lg:py-56">
        <div class="text-center">
          <h1 class="text-4xl font-bold tracking-tight text-gray-900 sm:text-5xl">
            <span class="text-indigo-600">Shorten links</span>
            and generate <span class="text-indigo-600">QR Codes</span>
            in a click
          </h1>
          <p class="mx-auto mt-6 max-w-md text-lg leading-8 text-gray-600">
            Simply paste your link, hit the button, and get a short link and QR code instantly!
          </p>
          <.form for={@form} class="mt-10 max-w-xl mx-auto" phx-submit="shorten_url">
            <.input field={@form[:target_url]} placeholder="Link to shorten" />
            <div class="mt-4 flex items-center justify-center gap-x-6">
              <button class="rounded-md bg-indigo-600 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">
                Shorten URL
              </button>
              <a href="#" class="pr-14 text-sm font-semibold leading-6 text-gray-900">
                Sign up <span aria-hidden="true">→</span>
              </a>
            </div>
          </.form>
        </div>
      </div>
      <div
        class="top-[calc(100%-13rem)] absolute inset-x-0 -z-10 transform-gpu overflow-hidden blur-3xl sm:top-[calc(100%-30rem)]"
        aria-hidden="true"
      >
        <div
          class="left-[calc(50%+3rem)] aspect-[1155/678] w-[36.125rem] from-[#ff80b5] to-[#9089fc] relative -translate-x-1/2 bg-gradient-to-tr opacity-30 sm:left-[calc(50%+36rem)] sm:w-[72.1875rem]"
          style="clip-path: polygon(74.1% 44.1%, 100% 61.6%, 97.5% 26.9%, 85.5% 0.1%, 80.7% 2%, 72.5% 32.5%, 60.2% 62.4%, 52.4% 68.1%, 47.5% 58.3%, 45.2% 34.5%, 27.5% 76.7%, 0.1% 64.9%, 17.9% 100%, 27.6% 76.8%, 76.1% 97.7%, 74.1% 44.1%)"
        >
        </div>
      </div>
    </div>
    """
  end
end
