defmodule Kierroskone.Repo.Migrations.AddDrivenAtToLaptime do
  use Ecto.Migration

  def change do
    alter table(:laptimes) do
      add(:driven_at, :string)
    end
  end
end
