module Homebrew
  def command
    cmd = ARGV.first
    cmd = HOMEBREW_INTERNAL_COMMAND_ALIASES.fetch(cmd, cmd)

    if (path = HOMEBREW_LIBRARY_PATH/"cmd/#{cmd}.rb").file?
      puts path
    elsif ARGV.homebrew_developer? && (path = HOMEBREW_LIBRARY_PATH/"dev-cmd/#{cmd}.rb").file?
      puts path
    elsif (path = which("brew-#{cmd}") || which("brew-#{cmd}.rb"))
      puts path
    else
      odie "Unknown command: #{cmd}"
    end
  end
end
