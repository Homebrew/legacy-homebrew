module Homebrew
  def cat
    # do not "fix" this to support multiple arguments, the output would be
    # unparsable, if the user wants to cat multiple formula they can call
    # brew cat multiple times.
    formulae = ARGV.formulae
    raise FormulaUnspecifiedError if formulae.empty?
    raise "`brew cat` doesn't support multiple arguments" if formulae.size > 1

    cd HOMEBREW_REPOSITORY
    exec "cat", formulae.first.path, *ARGV.options_only
  end
end
