require 'formula'

class Fatsort < Formula
  homepage 'http://fatsort.sourceforge.net/'
  url 'http://sourceforge.net/projects/fatsort/files/fatsort-1.0.1.314.tar.gz'
  sha1 'e05cef5ae6c1a795513a79e6960ead00d37038c2'

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install 'src/fatsort'
    man1.install 'man/fatsort.1'
  end
end
