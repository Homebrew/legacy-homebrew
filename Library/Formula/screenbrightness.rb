require 'formula'

class Screenbrightness < Formula
  homepage 'https://github.com/jmstacey/screenbrightness'
  url 'https://github.com/jmstacey/screenbrightness/archive/1.1.tar.gz'
  sha1 'f9750733ac298837f519fcfedcbfec74f781bc68'

  def install
    system "make"
    system "make", "prefix=#{prefix}", "install"
  end
end
