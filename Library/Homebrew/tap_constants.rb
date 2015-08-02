# match expressions when taps are given as ARGS, e.g. someuser/sometap
HOMEBREW_TAP_ARGS_REGEX = %r{^([\w-]+)/(homebrew-)?([\w-]+)$}
# match taps' formulae, e.g. someuser/sometap/someformula
HOMEBREW_TAP_FORMULA_REGEX = %r{^([\w-]+)/([\w-]+)/([\w+-.]+)$}
# match taps' directory paths, e.g. HOMEBREW_LIBRARY/Taps/someuser/sometap
HOMEBREW_TAP_DIR_REGEX = %r{#{Regexp.escape(HOMEBREW_LIBRARY.to_s)}/Taps/([\w-]+)/([\w-]+)}
# match taps' formula paths, e.g. HOMEBREW_LIBRARY/Taps/someuser/sometap/someformula
HOMEBREW_TAP_PATH_REGEX = Regexp.new(HOMEBREW_TAP_DIR_REGEX.source + %r{/(.*)}.source)
# match the default brew-cask tap e.g. Caskroom/cask
HOMEBREW_CASK_TAP_FORMULA_REGEX = %r{^(Caskroom)/(cask)/([\w+-.]+)$}
