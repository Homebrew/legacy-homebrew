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
    find_internal_commands HOMEBREW_LIBRARY_PATH/"cmd"
  end

  def internal_development_commands
    find_internal_commands HOMEBREW_LIBRARY_PATH/"dev-cmd"
  end

  def external_commands
    paths.reduce([]) do |cmds, path|
      Dir["#{path}/brew-*"].each do |file|
        next unless File.executable?(file)
        cmd = File.basename(file, ".rb")[5..-1]
        cmds << cmd unless cmd.include?(".")
      end
      cmds
    end.sort
  end

  private

  def find_internal_commands(directory)
    directory.children.reduce([]) do |cmds, f|
      cmds << f.basename.to_s.sub(/\.(?:rb|sh)$/, "") if f.file?
      cmds
    end
  end
end
