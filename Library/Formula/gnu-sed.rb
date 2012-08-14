require 'formula'

class GnuSed < Formula
  homepage 'http://www.gnu.org/software/sed/'
  url 'http://ftpmirror.gnu.org/sed/sed-4.2.1.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/sed/sed-4.2.1.tar.bz2'
  sha1 'ace93d23eabc00d3a8187ecf07d3a02b1b297810'

  option 'default-names', "Do not prepend 'g' to the binary"

  def install
    args = ["--prefix=#{prefix}", "--disable-dependency-tracking"]
    args << "--program-prefix=g" unless build.include? 'default-names'

    system "./configure", *args
    system "make install"
  end
end
