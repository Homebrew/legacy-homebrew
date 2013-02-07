def can_use_readline?
  not ENV['HOMEBREW_NO_READLINE']
end

require 'debrew/menu'
require 'debrew/raise_plus'
require 'debrew/irb' if can_use_readline?

class Object
  include RaisePlus
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
