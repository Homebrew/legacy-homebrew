# match expressions when taps are given as ARGS, e.g. someuser/sometap
HOMEBREW_TAP_ARGS_REGEX = %r{^([\w-]+)/(homebrew-)?([\w-]+)$}
# match taps' formula, e.g. someuser/sometap/someformula
HOMEBREW_TAP_FORMULA_REGEX = %r{^([\w-]+)/([\w-]+)/([\w+-]+)$}
# match taps' directory path, e.g. HOMEBREW_LIBRARY/Taps/someuser/sometap
HOMEBREW_TAP_DIR_REGEX = %r{#{HOMEBREW_LIBRARY}/Taps/([\w-]+)/([\w-]+)}
# match taps' formula path, e.g. HOMEBREW_LIBRARY/Taps/someuser/sometap/someformula
HOMEBREW_TAP_PATH_REGEX = Regexp.new(HOMEBREW_TAP_DIR_REGEX.source + %r{/(.*)}.source)
