require 'formula'

class Cowsay < Formula
  url 'http://www.nog.net/~tony/warez/cowsay-3.03.tar.gz'
  homepage 'http://www.nog.net/~tony/warez/cowsay.shtml'
  sha1 'e44dec32d2a462ed87f5e419237d6f236b87efe0'

  def install
    system "/bin/sh", "install.sh", prefix
    mv prefix+'man', share
  end
end
