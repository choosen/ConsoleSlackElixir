defmodule ElixirChat do

  def display_message(user, message) do
    IO.puts "#{user}: #{message}"
  end

  def start do
    user = IO.gets("Type in your name: ") |> String.strip
    IO.puts "Hi #{user}, you just joined a chat room! Type your message in and press enter."

    {:ok, conn} = AMQP.Connection.open
    {:ok, channel} = AMQP.Channel.open(conn)
    {:ok, queue_data} = AMQP.Queue.declare channel, ""

    AMQP.Exchange.fanout(channel, "super.chat")
    AMQP.Queue.bind channel, queue_data.queue, "super.chat"
    AMQP.Basic.consume channel, queue_data.queue

    spawn(fn ->
      wait_for_message(user, channel)
    end)
    listen_for_messages(channel, queue_data.queue)
  end

  def listen_for_messages(channel, queue_name) do
    receive do
      {:basic_deliver, payload, _meta} ->
        {:ok, data} = JSON.decode(payload)
        display_message(data["user"], data["message"])
        listen_for_messages(channel, queue_name)
    end
  end

  def wait_for_message(user, channel) do
    message = IO.gets("") |> String.strip
    publish_message(user, message, channel)
    spawn(fn ->
      wait_for_message(user, channel)
    end)
  end

  def publish_message(user, message, channel) do
    { :ok, data } = JSON.encode([user: user, message: message])
    AMQP.Basic.publish channel, "super.chat", "", data
  end

end

ElixirChat.start
