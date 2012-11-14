def can_use_readline?
  not ENV['HOMEBREW_NO_READLINE']
end

require 'irb' if can_use_readline?
require 'continuation' if RUBY_VERSION.to_f >= 1.9

class Menu
  attr_accessor :prompt
  attr_accessor :entries

  def initialize
    @entries = []
  end

  def choice(name, &action)
    entries << { :name => name, :action => action }
  end
end

def choose
  menu = Menu.new
  yield menu

  choice = nil
  while choice.nil?
    menu.entries.each_with_index do |entry, i|
      puts "#{i+1}. #{entry[:name]}"
    end
    print menu.prompt unless menu.prompt.nil?
    reply = $stdin.gets.chomp

    i = reply.to_i
    if i > 0
      choice = menu.entries[i-1]
    else
      possible = menu.entries.find_all {|e| e[:name].to_s.start_with? reply }
      case possible.size
        when 0 then puts "No such option"
        when 1 then choice = possible.first
        else puts "Multiple options match: #{possible.map{|e| e[:name]}.join(' ')}"
      end
    end
  end
  choice[:action].call
end


module IRB
  @setup_done = false

  def IRB.start_within(binding)
    unless @setup_done
      # make IRB ignore our command line arguments
      saved_args = ARGV.shift(ARGV.size)
      IRB.setup(nil)
      ARGV.concat(saved_args)
      @setup_done = true
    end

    workspace = WorkSpace.new(binding)
    irb = Irb.new(workspace)

    @CONF[:IRB_RC].call(irb.context) if @CONF[:IRB_RC]
    @CONF[:MAIN_CONTEXT] = irb.context

    trap("SIGINT") do
      irb.signal_handle
    end

    begin
      catch(:IRB_EXIT) do
        irb.eval_input
      end
    ensure
      irb_at_exit
    end
  end
end if can_use_readline?

class Exception
  attr_accessor :continuation

  def restart(&block)
    continuation.call block
  end
end

def has_debugger?
  begin
    require 'rubygems'
    require 'ruby-debug'
    true
  rescue LoadError
    false
  end if can_use_readline?
end

def debrew(exception, formula=nil)
  puts "#{exception.backtrace.first}"
  puts "#{Tty.red}#{exception.class.to_s}#{Tty.reset}: #{exception.to_s}"

  begin
    again = false
    choose do |menu|
      menu.prompt = "Choose an action: "
      menu.choice(:raise) { original_raise exception }
      menu.choice(:ignore) { exception.restart }
      menu.choice(:backtrace) { puts exception.backtrace; again = true }
      menu.choice(:debug) do
        puts "When you exit the debugger, execution will continue."
        exception.restart { debugger }
      end if has_debugger?
      menu.choice(:irb) do
        puts "When you exit this IRB session, execution will continue."
        exception.restart do
          # we need to capture the binding after returning from raise
          set_trace_func proc { |event, file, line, id, binding, classname|
            if event == 'return'
              set_trace_func nil
              IRB.start_within(binding)
            end
          }
        end
      end if can_use_readline?
      menu.choice(:shell) do
        puts "When you exit this shell, you will return to the menu."
        interactive_shell formula
        again=true
      end
    end
  end while again
end

module RaisePlus
  alias :original_raise :raise

  def raise(*args)
    exception = case
      when args.size == 0 then ($!.nil? ? RuntimeError.exception : $!)
      when (args.size == 1 and args[0].is_a?(String)) then RuntimeError.exception(args[0])
      else args[0].exception(args[1]) # this does the right thing if args[1] is missing
    end
    # passing something other than a String or Exception is illegal, but if someone does it anyway,
    # that object won't have backtrace or continuation methods. in that case, let's pass it on to
    # the original raise, which will reject it
    return super exception unless exception.is_a?(Exception)

    # keep original backtrace if reraising
    exception.set_backtrace(args.size >= 3 ? args[2] : caller) if exception.backtrace.nil?

    blk = callcc do |cc|
      exception.continuation = cc
      super exception
    end
    blk.call unless blk.nil?
  end

  alias :fail :raise
end

class Object
  include RaisePlus
end
