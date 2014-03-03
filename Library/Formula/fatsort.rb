require 'formula'

class Fatsort < Formula
  homepage 'http://fatsort.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/fatsort/fatsort-1.2.355.tar.gz'
  sha1 'e0138bebf4f27c2f15684b79e8009b9a3c515e9b'

  depends_on 'help2man'

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install 'src/fatsort'
    man1.install 'man/fatsort.1'
  end
end
