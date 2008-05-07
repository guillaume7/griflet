#! /usr/bin/env ruby

class Greeter
    def initialize(name = "world")
        @name = name
    end
    def say_hi
        puts "Hi #{@name}!"
    end
    def say_bye
        puts "Bye #{@name}, come back soon."
    end
end

if __FILE__ == $0
    greet = Greeter.new
    greet.say_hi
    greet.say_bye
end
