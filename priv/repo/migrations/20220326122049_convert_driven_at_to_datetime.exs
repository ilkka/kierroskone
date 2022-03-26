defmodule Kierroskone.Repo.Migrations.ConvertDrivenAtToDatetime do
  use Ecto.Migration

  def up do
    execute "alter table laptimes rename column driven_at to driven_at_str;"
    execute "alter table laptimes add column driven_at timestamp;"

    execute "update laptimes set driven_at = to_timestamp(driven_at_str, 'YYYY-MM-DD HH24:MI:SS');"

    execute "alter table laptimes drop column driven_at_str;"
  end

  def down do
    execute "alter table laptimes drop column driven_at;"
    execute "alter table laptimes add column driven_at varchar(255);"
  end
end
