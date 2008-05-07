#! /usr/bin/env ruby

class Greeter
    attr_accessor :name

    # Create the object
    def initialize(name = "world")
        @name = name.capitalize
    end

    # Say hi
    def say_hi
        puts "Hi #{@name}!"
    end

    #Say bye
    def say_bye
        puts "Bye #{@name}, come back soon."
    end

end

if __FILE__ == $0
    greet = Greeter.new("griflet")
    greet.say_hi
    greet.say_bye

    greet.name="xana"
    greet.say_hi
    greet.say_bye

    greet = Greeter.new("xana")
    greet.say_hi
    greet.say_bye
end
