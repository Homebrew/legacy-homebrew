require 'formula'

class Ministat < Formula
  version '0.1'
  homepage 'https://github.com/codahale/ministat'
  url 'https://github.com/codahale/ministat/tarball/master'
  sha1 'd2a2e4850c58ee942290475befef9d8a89c8c531'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "ruby -e 'puts 1; puts 2; puts 3' | ministat"
  end
end
