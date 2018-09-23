defmodule Hello.NodeInfo do
  use GenServer

  def info(name) do
    GenServer.call({__MODULE__, name}, {:info})
  end

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def handle_call({:info}, _from, []) do
    reply = %{
      app_version: Hello.version(),
      elixir_version: System.version(),
      erlang_version: :erlang.system_info(:otp_release)
    }

    {:reply, reply, []}
  end
end
