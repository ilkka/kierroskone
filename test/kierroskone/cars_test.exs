defmodule Kierroskone.CarsTest do
  use Kierroskone.DataCase

  alias Kierroskone.Cars

  describe "classes" do
    alias Kierroskone.Cars.Class

    import Kierroskone.CarsFixtures

    @invalid_attrs %{name: nil}

    test "list_classes/0 returns all classes" do
      class = class_fixture()
      assert Cars.list_classes() == [class]
    end

    test "get_class!/1 returns the class with given id" do
      class = class_fixture()
      assert Cars.get_class!(class.id) == class
    end

    test "create_class/1 with valid data creates a class" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Class{} = class} = Cars.create_class(valid_attrs)
      assert class.name == "some name"
    end

    test "create_class/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cars.create_class(@invalid_attrs)
    end

    test "update_class/2 with valid data updates the class" do
      class = class_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Class{} = class} = Cars.update_class(class, update_attrs)
      assert class.name == "some updated name"
    end

    test "update_class/2 with invalid data returns error changeset" do
      class = class_fixture()
      assert {:error, %Ecto.Changeset{}} = Cars.update_class(class, @invalid_attrs)
      assert class == Cars.get_class!(class.id)
    end

    test "delete_class/1 deletes the class" do
      class = class_fixture()
      assert {:ok, %Class{}} = Cars.delete_class(class)
      assert_raise Ecto.NoResultsError, fn -> Cars.get_class!(class.id) end
    end

    test "change_class/1 returns a class changeset" do
      class = class_fixture()
      assert %Ecto.Changeset{} = Cars.change_class(class)
    end
  end

  describe "cars" do
    alias Kierroskone.Cars.Car

    import Kierroskone.CarsFixtures

    @invalid_attrs %{name: nil}

    test "list_cars/0 returns all cars" do
      car = car_fixture()
      assert Cars.list_cars() == [car]
    end

    test "get_car!/1 returns the car with given id" do
      car = car_fixture()
      assert Cars.get_car!(car.id) == car
    end

    test "create_car/1 with valid data creates a car" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Car{} = car} = Cars.create_car(valid_attrs)
      assert car.name == "some name"
    end

    test "create_car/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Cars.create_car(@invalid_attrs)
    end

    test "update_car/2 with valid data updates the car" do
      car = car_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Car{} = car} = Cars.update_car(car, update_attrs)
      assert car.name == "some updated name"
    end

    test "update_car/2 with invalid data returns error changeset" do
      car = car_fixture()
      assert {:error, %Ecto.Changeset{}} = Cars.update_car(car, @invalid_attrs)
      assert car == Cars.get_car!(car.id)
    end

    test "delete_car/1 deletes the car" do
      car = car_fixture()
      assert {:ok, %Car{}} = Cars.delete_car(car)
      assert_raise Ecto.NoResultsError, fn -> Cars.get_car!(car.id) end
    end

    test "change_car/1 returns a car changeset" do
      car = car_fixture()
      assert %Ecto.Changeset{} = Cars.change_car(car)
    end
  end
end
