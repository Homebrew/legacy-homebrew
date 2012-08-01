require 'formula'

module Homebrew extend self
  def stop
    _do_stop( ARGV.formulae.first )
  end

  private
  def _do_stop(formula)
    if formula.nil?
      _exit_with_error "No formula, no party."
    elsif ( command = formula.stop_command )
      exec command
    else
      _exit_with_error "No stop command specified for: #{ formula.name }."
    end
  end

  def _exit_with_error(message)
    onoe message
    exit(1)
  end
end
