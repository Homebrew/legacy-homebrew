require 'formula'

class Jarbundler < Formula
  homepage 'http://informagen.com/JarBundler/'
  url 'http://informagen.com/JarBundler/dist/jarbundler.tar.gz'
  sha1 '6ffc3eca15bc956a83e0ceee443056679089a2c8'
  version '2.2.0'

  depends_on :ant

  def install
    cp Dir['jarbundler-2.2.0.jar'], "#{HOMEBREW_PREFIX}/Library/LinkedKegs/ant/libexec/lib/"
  end
end
