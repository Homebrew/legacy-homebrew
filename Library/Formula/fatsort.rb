require 'formula'

class Fatsort < Formula
  homepage 'http://fatsort.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/fatsort/fatsort-1.3.365.tar.gz'
  sha1 '9ae5d1ab5e4c91e6725237fab1271f881c3edb59'

  depends_on 'help2man'

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install 'src/fatsort'
    man1.install 'man/fatsort.1'
  end
end
