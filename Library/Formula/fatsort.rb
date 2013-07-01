require 'formula'

class Fatsort < Formula
  homepage 'http://fatsort.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/fatsort/fatsort-1.1.1.336.tar.gz'
  sha1 '03a070603e7d48a98efd13166a2cc798141d0678'

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install 'src/fatsort'
    man1.install 'man/fatsort.1'
  end
end
