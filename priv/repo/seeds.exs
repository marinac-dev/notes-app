# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Notes.Repo.insert!(%Notes.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Notes.Accounts

user_params = %{username: "admin", password: "RaU#ok#fpo5CJRfNzj2r@F8R^KE*P^Y$"}
{:ok, user} = Accounts.create_user(user_params)

user_params = %{username: "admin2", password: "4CxvzrGt!C2Tkn%ej5vDnuG%mLq&yg6z"}
{:ok, user2} = Accounts.create_user(user_params)

user_params = %{username: "admin3", password: "h3xN@63x*am!3sdnnAtLgsXieY78M*tx"}
{:ok, user3} = Accounts.create_user(user_params)

text1 = "Ex dolore cupidatat minim ullamco eu deserunt pariatur tempor aute."
text2 = "Laboris laboris nulla commodo veniam id occaecat mollit laboris aute."
text3 = "Non minim amet dolore laborum ex."

{:ok, note} = Accounts.create_note(%{user_id: user.id, content: text1})
{:ok, note2} = Accounts.create_note(%{user_id: user2.id, content: text2})
{:ok, note3} = Accounts.create_note(%{user_id: user3.id, content: text3})

{:ok, file} =
  Accounts.create_file(%{
    name: "water_flow",
    extension: ".mp3",
    user_id: user.id,
    note_id: note.id,
    file_content: File.read!("test/files/pixel.txt")
  })

Accounts.create_share(%{
  owner_id: user.id,
  share_id: user2.id,
  note_id: note.id
})
