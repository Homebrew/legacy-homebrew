require 'formula'

# Require php to get the base class
require Formula.path('php')

class PhpGd <BundledPhpExtensionFormula
  homepage 'http://php.net/gd'

  depends_on "jpeg"

  configure_args [
    "--with-freetype-dir=/usr/X11",
    "--with-png-dir=/usr/X11",
    "--with-zlib-dir=/usr",
    "--with-jpeg-dir=#{HOMEBREW_PREFIX}",
    "--enable-gd-native-ttf"
  ]
end
