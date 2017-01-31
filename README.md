Chat console application (Elixir edition)
================

This application communicate with [ruby one](https://github.com/choosen/ConsoleSlackRuby), through RabbitMQ message broker

### :hash: App description
-------------
Simple console chat application.
Asking for name, joining to chat room, sending and receiving messages.

### :closed_lock_with_key: Technology stack
-------------

| Name |  Version |
| :--: | :---: |
| [Erlang](https://www.erlang.org/) | OTP 19 |
| [Elixir](https://www.ruby-lang.org) | 1.4.0 |
| [RabbitMQ](https://www.rabbitmq.com/) | 3.6.6 |

### :book: Setup
-------------
1. clone repository,
2. `cd path/to/repo`,
3. `mix deps.get`.

### :book: Run
-------------
* `mix`
* on other terminal `mix` or run [ruby application](https://github.com/choosen/ConsoleSlackRuby)

### :information_source: Dependencies
-------------

* [json](https://github.com/cblage/elixir-json)
* [amqp](https://github.com/pma/amqp),
* [amqp_client](https://github.com/rabbitmq/rabbitmq-erlang-client).

### :information_source: How to install RabbitMQ
-------------
* [Installation instructions](https://www.rabbitmq.com/download.html)
