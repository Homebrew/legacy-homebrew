require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpImap <BundledPhpExtensionFormula
  homepage 'http://php.net/imap'

  depends_on "imap"

  configure_args [
    "--with-imap=#{HOMEBREW_PREFIX}"
  ]
end
