module Homebrew
  def commands
    if ARGV.include? "--quiet"
      cmds = internal_commands + external_commands
      cmds += internal_development_commands if ARGV.homebrew_developer?
      cmds += HOMEBREW_INTERNAL_COMMAND_ALIASES.keys if ARGV.include? "--include-aliases"
      puts_columns cmds.sort
    else
      # Find commands in Homebrew/cmd
      puts "Built-in commands"
      puts_columns internal_commands

      # Find commands in Homebrew/dev-cmd
      if ARGV.homebrew_developer?
        puts
        puts "Built-in development commands"
        puts_columns internal_development_commands
      end

      # Find commands in the path
      unless (exts = external_commands).empty?
        puts
        puts "External commands"
        puts_columns exts
      end
    end
  end

  def internal_commands
    (HOMEBREW_LIBRARY_PATH/"cmd").children.select(&:file?).map { |f| f.basename(".rb").to_s }
  end

  def internal_development_commands
    (HOMEBREW_LIBRARY_PATH/"dev-cmd").children.select(&:file?).map { |f| f.basename(".rb").to_s }
  end

  def external_commands
    paths.flat_map { |p| Dir["#{p}/brew-*"] }.
      select { |f| File.executable?(f) }.
      map { |f| File.basename(f, ".rb")[5..-1] }.
      reject { |f| f =~ /\./ }.
      sort
  end
end
