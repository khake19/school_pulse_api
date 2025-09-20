# defmodule SchoolPulseAPiWeb.Plugs.TeacherActivitiyLogger do

#   @moduledoc """
#   hello
#   """

#   import SchoolPulseApiWeb.Plugs.ActivityLoggerHelper, only: [init_config: 1, should_log?: 2, get_action: 1]

#   def init(opts) do
#     init_config(opts)
#   end

#   def call(conn, config) do
#     if should_log?(conn, config) do
#       require IEx; IEx.pry()
#     end
#   end

#   def log_activity(conn) do
#     action = get_action(conn)

#     case action do
#       :create -> log_created(conn)
#       :update -> log_updated(conn)
#       :delete -> log_deleted(conn)
#       _ -> :ok
#     end
#   end

#   def log_created(conn) do

#   end

#   def log_updated(conn) do
#   end

#   def log_deleted(conn) do
#   end
# end
