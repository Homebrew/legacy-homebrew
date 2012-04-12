require 'formula'

class Dupx < Formula
  homepage 'http://www.isi.edu/~yuri/dupx/'
  url 'http://www.isi.edu/~yuri/dupx/dupx-0.1.tar.gz'
  md5 'e9231c08328e6a04ba76fc4e69732a6c'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
