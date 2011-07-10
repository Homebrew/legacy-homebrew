require 'formula'

class Lltag < Formula
  url 'http://download.gna.org/lltag/lltag-0.14.3.tar.bz2'
  homepage 'http://home.gna.org/lltag/'
  md5 'fdd0fdb9a0228bbc8b6bad6199dd4500'

  def install
    system "make"
    system "make install PREFIX=#{prefix}"
  end
end