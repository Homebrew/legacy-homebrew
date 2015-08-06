require "mutex_m"
require "debrew/irb"

module Debrew
  extend Mutex_m

  Ignorable = Module.new

  module Raise
    def raise(*)
      super
    rescue Exception => e
      e.extend(Ignorable)
      super(e) unless Debrew.debug(e) == :ignore
    end

    alias_method :fail, :raise
  end

  module Formula
    def install
      Debrew.debrew { super }
    end

    def patch
      Debrew.debrew { super }
    end

    def test
      Debrew.debrew { super }
    end
  end

  class Menu
    Entry = Struct.new(:name, :action)

    attr_accessor :prompt, :entries

    def initialize
      @entries = []
    end

    def choice(name, &action)
      entries << Entry.new(name.to_s, action)
    end

    def self.choose
      menu = new
      yield menu

      choice = nil
      while choice.nil?
        menu.entries.each_with_index { |e, i| puts "#{i+1}. #{e.name}" }
        print menu.prompt unless menu.prompt.nil?

        input = $stdin.gets || exit
        input.chomp!

        i = input.to_i
        if i > 0
          choice = menu.entries[i-1]
        else
          possible = menu.entries.find_all { |e| e.name.start_with?(input) }

          case possible.size
          when 0 then puts "No such option"
          when 1 then choice = possible.first
          else puts "Multiple options match: #{possible.map(&:name).join(" ")}"
          end
        end
      end

      choice[:action].call
    end
  end

  class << self
    alias_method :original_raise, :raise
  end

  @active = false
  @debugged_exceptions = Set.new

  def self.active?
    @active
  end

  class << self
    attr_reader :debugged_exceptions
  end

  def self.debrew
    @active = true
    Object.send(:include, Raise)

    begin
      yield
    rescue SystemExit
      original_raise
    rescue Exception => e
      debug(e)
    ensure
      @active = false
    end
  end

  def self.debug(e)
    original_raise(e) unless active? &&
                             debugged_exceptions.add?(e) &&
                             try_lock

    begin
      puts "#{e.backtrace.first}"
      puts "#{Tty.red}#{e.class.name}#{Tty.reset}: #{e}"

      loop do
        Menu.choose do |menu|
          menu.prompt = "Choose an action: "

          menu.choice(:raise) { original_raise(e) }
          menu.choice(:ignore) { return :ignore } if Ignorable === e
          menu.choice(:backtrace) { puts e.backtrace }

          menu.choice(:irb) do
            puts "When you exit this IRB session, execution will continue."
            set_trace_func proc { |event, _, _, id, binding, klass|
              if klass == Raise && id == :raise && event == "return"
                set_trace_func(nil)
                synchronize { IRB.start_within(binding) }
              end
            }

            return :ignore
          end if Ignorable === e

          menu.choice(:shell) do
            puts "When you exit this shell, you will return to the menu."
            interactive_shell
          end
        end
      end
    ensure
      unlock
    end
  end
end
