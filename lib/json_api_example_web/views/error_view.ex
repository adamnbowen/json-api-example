defmodule JsonApiExampleWeb.ErrorView do
  use JsonApiExampleWeb, :view
  
  alias JsonApiExampleWeb.ErrorHelpers

  def render("error.json", %{changeset: changeset}) do
    %{error:
      %{message: Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)}}
  end

  def render("error.json", %{message: message}) do
    %{error: %{message: message}}
  end

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end
end
