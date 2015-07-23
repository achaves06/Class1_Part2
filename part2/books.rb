module OffRoadable
  def can_off_road
    puts "I can go off road"
  end
end

class Vehicle
  @@vehicle_count = 0

  attr_accessor :speed, :color
  attr_reader :year, :model

  def initialize(year, color, model)
    @color = color
    @model = model
    @year = year
    @speed = 0
    @@vehicle_count +=1
  end

  def speed_up
    self.speed = 60
    puts "The car's speed is now #{self.speed}"
  end

  def slow_down
    self.speed = 25
    puts "The car's speed is now #{self.speed}"
  end

  def shut_off
    self.speed = 0
    puts "The car's speed is now #{self.speed}, we are shutting it off"
  end

  def spray_paint(color)
    self.color = color
  end

  def to_s
    puts "I am a #{self.year} #{self.color} #{self.model} and I am #{age} years old"
  end

  def put_number_of_cars
    puts "I have #{@@vehicle_count} vehicles"
  end

  def self.gas_mileage(miles, gallons_of_gas)
    puts "This car gets #{miles/gallons_of_gas} miles per gallon"
  end

  private

  def age
    Time.now.year - self.year
  end

end

class MyCar < Vehicle

  DOOR_NUMBER = 4

end

class MyTruck < Vehicle
  include OffRoadable
  DOOR_NUMBER = 2
end

kia = MyCar.new(1998, "blue", "sportage")
kia.speed_up
kia.slow_down
kia.shut_off
kia.spray_paint("black")
puts "The kia is now #{kia.color}"

clunker = MyCar.new(2004, "black", "Trailblazer")
clunker.to_s
MyCar.gas_mileage(350,19)

#3 error is happening because name is set as read only, if instead of attr_reader we use attr_accessor, we will be able to assign a new name to it as well

puts MyCar.ancestors
puts MyTruck.ancestors
puts Vehicle.ancestors


class Student
  attr_accessor :name
  attr_writer :grade

  def initialize(name, grade)
    @name = name
    @grade = grade
  end

  def better_grade_than?(student)
    puts "Well Done!" if grade > student.grade
  end

  protected

  def grade
    @grade
  end
end

bob = Student.new("Bob", 75)
joe = Student.new("Joe", 100)

joe.better_grade_than?(bob)
