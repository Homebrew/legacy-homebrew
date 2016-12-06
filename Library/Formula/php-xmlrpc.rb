require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpXmlrpc <BundledPhpExtensionFormula
  homepage 'http://php.net/xmlrpc'

  def install
    ENV.append 'CPPFLAGS', `xml2-config --cflags`.chomp
    super
  end
end
