# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Kierroskone.Repo.insert!(%Kierroskone.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Kierroskone.Repo
alias Kierroskone.{Games.Game, Cars.Car, Cars.Class, Tracks.Track}

dirt =
  Repo.insert!(%Game{
    name: "Dirt Rally 2.0"
  })

ac =
  Repo.insert!(%Game{
    name: "Assetto Corsa"
  })

group_a =
  Repo.insert!(%Class{
    name: "Modern Rally Group A",
    game_id: dirt.id
  })

evo =
  Repo.insert!(%Car{
    name: "Mitsubishi Lancer Evolution VI",
    class_id: group_a.id,
    game_id: dirt.id
  })

oksala =
  Repo.insert!(%Track{
    name: "Oksala",
    game_id: dirt.id
  })
