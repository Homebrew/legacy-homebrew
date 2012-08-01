require 'formula'

module Homebrew extend self
  def start
    _do_start( ARGV.formulae.first )
  end

  private
  def _do_start(formula)
    if formula.nil?
      _exit_with_error "No formula, no party."
    elsif ! formula.installed?
      _exit_with_error "#{ formula.name } isn't installed. Please run:\n\tbrew install #{ formula.name }"
    elsif ( command = formula.start_command )
      exec command
    else
      _exit_with_error "No start command specified for: #{ formula.name }."
    end
  end

  def _exit_with_error(message)
    onoe message
    exit(1)
  end
end
