module Homebrew extend self
  def cat
    # do not "fix" this to support multiple arguments, the output would be
    # unparsable, if the user wants to cat multiple formula they can call
    # brew cat multiple times.

    cd HOMEBREW_REPOSITORY
    exec "cat", ARGV.formulae.first.path, *ARGV.options_only
  end
end
