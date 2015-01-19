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
