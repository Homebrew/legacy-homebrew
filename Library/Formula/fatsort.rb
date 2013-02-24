require 'formula'

class Fatsort < Formula
  homepage 'http://fatsort.sourceforge.net/'
  url 'http://sourceforge.net/projects/fatsort/files/fatsort-0.9.17.269.tar.gz'
  sha1 '43283ecd1dcbde43e1cf2b383d40e750338174cb'

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install 'src/fatsort'
    man1.install 'man/fatsort.1'
  end
end
