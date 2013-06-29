require 'formula'

class GnuUnits < Formula
  homepage 'http://www.gnu.org/software/units/'
  url 'http://ftpmirror.gnu.org/units/units-2.01.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/units/units-2.01.tar.gz'
  sha1 '80e7f1a2e70769bfac93702924871843b85f12d4'

  option 'default-names', "Do not prepend 'g' to the binary"

  def install
    args = ["--prefix=#{prefix}"]
    args << "--program-prefix=g" unless build.include? 'default-names'

    system "./configure", *args
    system "make install"
  end
end
