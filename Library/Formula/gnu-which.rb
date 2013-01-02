require 'formula'

class GnuWhich < Formula
  homepage 'http://carlo17.home.xs4all.nl/which/'
  url 'http://ftpmirror.gnu.org/which/which-2.20.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/which/which-2.20.tar.gz'
  sha1 '3bcd6d87aa5231917ba7123319eedcae90cfa0fd'

  option 'default-names', "Do not prepend 'g' to the binary"

  def install
    args = ["--prefix=#{prefix}", "--disable-dependency-tracking"]
    args << "--program-prefix=g" unless build.include? 'default-names'

    system "./configure", *args
    system "make install"
  end
end
