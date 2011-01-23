require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpXsl <BundledPhpExtensionFormula
  homepage 'http://php.net/xsl'

  configure_args [
    "--with-xsl=/usr"
  ]

  def install
    ENV.append 'CPPFLAGS', "-I#{HOMEBREW_PREFIX}/include/php/ext/dom"
    super
  end
end
