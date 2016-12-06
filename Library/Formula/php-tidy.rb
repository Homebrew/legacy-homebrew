require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpTidy <BundledPhpExtensionFormula
  homepage 'http://php.net/tidy'

  depends_on "https://github.com/adamv/homebrew/raw/duplicates/Library/Formula/tidy.rb"

  configure_args [
    "--with-tidy=#{HOMEBREW_PREFIX}"
  ]
end
