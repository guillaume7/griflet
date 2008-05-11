#! /usr/bin/env ruby
#=Greeter class
#
#This class aims at illustrate how to build a cute nice little hello world program.
#I hope you enjoy it
#==initialize
#==say_hi
#==say_bye
#==ask_how

class Greeter
    attr_accessor :names

    # Create the object
    def initialize(names = "world")
        if names.respond_to?("capitalize")
            @names = names.capitalize
        else
            @names = names
        end
    end

    # Say hi to everybody
    def say_hi
        if @names.nil?
            puts "..."
        else 
            if @names.respond_to?("each")
                @names.each do |name|
                    puts "Hello #{name.capitalize}!"
                end
            else
                puts "Hi #{@names}!"
            end
        end
    end

    #Say bye
    def say_bye
        if @names.nil?
            puts "..."
        else 
            if @names.respond_to?("join")
                puts "Bye #{@names.join(", ")}, come back soon!"
            else
                puts "Bye #{@names.capitalize}, come back soon!"
            end
        end
    end

    #Ask how are you
    def ask_feel
        if @names.nil?
            puts "..."
        else
            if @names.respond_to?("each")
                @names.each do |name|
                    puts "Hey #{name.capitalize}, how do you feel?"
                end
            else
                puts "Hey #{@names.capitalize}, how do you feel?"
            end
        end
    end

end

if __FILE__ == $0
    greet = Greeter.new("griflet")
    greet.say_hi
    greet.say_bye
    greet.ask_feel

    # Change name to "xana"
    greet.names="xana"
    greet.say_hi
    greet.say_bye
    greet.ask_feel

    # Create new object with "Xana"
    greet = Greeter.new("xana")
    greet.say_hi
    greet.say_bye
    greet.ask_feel

    # Change name for a swarm of names!
    greet = Greeter.new(["griflet", "cepheus", "macleod", "guimas"])
    greet.say_hi
    greet.say_bye
    greet.ask_feel

    # Change to nil
    greet.names = nil
    greet.say_hi
    greet.say_bye
    greet.ask_feel
end
