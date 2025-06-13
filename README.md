# SchoolPulseApi

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).


#### How to deploy to fly.io

https://fly.io/docs/elixir/getting-started/

#### Start VM
`flyctl machine start`

#### Check VM
`flyctl status`

#### Deply changes
`fly deploy`

#### SSH to console
`fly ssh console --pty -C "/app/bin/school_pulse_api remote"`




### How to connect to postgres

#### Connect to postgress
`fly postgres connect -a school-pulse-api-db`

#### List of databases
`\l`

#### Connect to school pulse api
`\c school_pulse_api`

#### List of relationship
`\dt`


### How to detach db to app

#### unset DATABASE_URL first
`fly secrets unset DATABASE_URL`


#### How to check secrets list
`fly secrets list`


### How to connect postgres to api school pulse api
`fly postgres attach school-pulse-api-db --app school-pulse-api`



### How to run seeds in production

#### SSH to console
`fly ssh console --pty -C "/app/bin/school_pulse_api remote"`

#### Run Global Setup to seeds data
`GlobalSetup.run()`


### How to connect Postres to your local
#### proxy connection
`fly proxy 15432:5432 -a school-pulse-api-db`



### Phoenix: Ecto migrations cheatsheet
https://devhints.io/phoenix-migrations

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
