defmodule Kierroskone.CarsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Kierroskone.Cars` context.
  """

  @doc """
  Generate a class.
  """
  def class_fixture(attrs \\ %{}) do
    {:ok, class} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Kierroskone.Cars.create_class()

    class
  end

  @doc """
  Generate a car.
  """
  def car_fixture(attrs \\ %{}) do
    {:ok, car} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Kierroskone.Cars.create_car()

    car
  end
end
