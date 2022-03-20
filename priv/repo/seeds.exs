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
alias Kierroskone.{Games.Game, Cars.Car, Cars.Class, Tracks.Track, Users.User, Tracks.Laptime}

dirt =
  Repo.insert!(%Game{
    name: "Dirt Rally 2.0"
  })

ac =
  Repo.insert!(%Game{
    name: "Assetto Corsa"
  })

dirt_group_a =
  Repo.insert!(%Class{
    name: "Modern Rally Group A",
    game_id: dirt.id
  })

evo =
  Repo.insert!(%Car{
    name: "Mitsubishi Lancer Evolution VI",
    class_id: dirt_group_a.id
  })

oksala =
  Repo.insert!(%Track{
    name: "Oksala",
    game_id: dirt.id
  })

ahto = Repo.insert!(%User{name: "Ahto Simakuutio"})

record = Repo.insert!(%Laptime{milliseconds: 4 * 60 * 1000, car_id: evo.id, track_id: oksala.id})
