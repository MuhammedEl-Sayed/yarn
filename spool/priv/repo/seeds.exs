# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Spool.Repo.insert!(%Spool.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
# priv/repo/seeds.exs
alias Spool.Accounts.User
alias Spool.Accounts.ApiKey

expires_at = DateTime.utc_now() |> DateTime.add(365, :day)

for label <- ["Coke", "Georgie"] do
  user =
    User
    |> Ash.Changeset.for_create(:create, %{})
    |> Ash.create!()

  api_key =
    ApiKey
    |> Ash.Changeset.for_create(:create, %{user_id: user.id, expires_at: expires_at})
    |> Ash.create!()

  IO.puts("""
  ---
  #{label}
  User ID: #{user.id}
  API Key: #{api_key.__metadata__.plaintext_api_key}
  ---
  """)
end
