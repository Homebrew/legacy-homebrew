require 'debrew/menu'
require 'debrew/raise_plus'

unless ENV['HOMEBREW_NO_READLINE']
  begin
    require 'rubygems'
    require 'ruby-debug'
  rescue LoadError
  end

  require 'debrew/irb'
end

class Object
  include RaisePlus
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
      end if Object.const_defined?(:Debugger)
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
      end if Object.const_defined?(:IRB)
      menu.choice(:shell) do
        puts "When you exit this shell, you will return to the menu."
        interactive_shell formula
        again=true
      end
    end
  end while again
end
