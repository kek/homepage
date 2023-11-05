defmodule Hello do
  @git_commit :os.cmd(~c"git rev-parse HEAD") |> List.to_string() |> String.trim()
  @mix_app_version Mix.Project.config()[:version]

  def version do
    @mix_app_version <> "-" <> ("#{@git_commit}" |> String.slice(0..5))
  end

  def nodes do
    # [:"hello@pablo.local", :"hello@ingrid.local", :"hello@harry.local"]
    [:"hello@pablo.local"]
  end
end
