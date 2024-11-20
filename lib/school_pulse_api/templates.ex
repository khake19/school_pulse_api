defmodule SchoolPulseApi.Templates do
  import Ecto.Query, warn: false
  alias SchoolPulseApi.Repo

  alias SchoolPulseApi.Templates.Template

  def get_template!(id), do: Repo.get!(Template, id)

end
