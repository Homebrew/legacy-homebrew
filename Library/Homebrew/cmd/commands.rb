module Homebrew
  def commands
    # Find commands in Homebrew/cmd
    cmds = (HOMEBREW_REPOSITORY/"Library/Homebrew/cmd").
           children(with_directory=false).
           map {|f| File.basename(f, '.rb')}
    puts "Built-in commands"
    puts_columns cmds

    # Find commands in the path
    exts =  paths.map{ |p| Dir["#{p}/*"] }.flatten.
            map{    |f| File.basename f }.
            select{ |f| f =~ /^brew-(.+)/ }.
            map{    |f| File.basename(f, '.rb')[5..-1] }.
            reject{ |f| f =~ /\./ }

    unless exts.empty?
      puts
      puts "External commands"
      puts_columns exts
    end
  end
end
