defmodule ElixirChat do
  # formats display of messages
  def display_message(user, message) do
    IO.puts "#{user}: #{message}"
  end

  def start do
    # gets user name from console
    user = IO.gets("Type in your name: ") |> String.strip
    IO.puts "Hi #{user}, you just joined a chat room! Type your message in and press enter."

    # initialize AMQP with default local machine and bind connection
    {:ok, conn} = AMQP.Connection.open
    # create channel - key of communication
    {:ok, channel} = AMQP.Channel.open(conn)
    # set random, uniq queue name for storing messages
    {:ok, queue_data} = AMQP.Queue.declare channel, ""

    # create exchange to instrested in super.chat
    AMQP.Exchange.fanout(channel, "super.chat")
    # bind channel with uniq queue_data to receive messages
    AMQP.Queue.bind channel, queue_data.queue, "super.chat"

    listen_for_messages(channel, queue_data.queue)
    wait_for_message(user, channel)
  end

  def listen_for_messages(channel, queue_name) do
    # subscribe queue to fanout exchange, parse JSON message
    # and print it in console
    AMQP.Queue.subscribe channel, queue_name, fn(payload, _meta) ->
      {:ok, data} = JSON.decode(payload)
      display_message(data["user"], data["message"])
    end
  end

  # infinite loop for get input from console and publish it to others
  # elixir handle recursion to use it like 'normal' loop in other languages
  def wait_for_message(user, channel) do
    message = IO.gets("") |> String.strip
    publish_message(user, message, channel)
    wait_for_message(user, channel)
  end

  def publish_message(user, message, channel) do
    { :ok, data } = JSON.encode([user: user, message: message])
    # publish prepared data to server, message will be delivered to
    # channels with apriopriate fanout exchange
    AMQP.Basic.publish channel, "super.chat", "", data
  end
end

# initialize object
ElixirChat.start
