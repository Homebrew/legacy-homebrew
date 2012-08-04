require 'formula'

class GnuUnits < Formula
  homepage 'http://www.gnu.org/software/units/'
  url 'http://ftpmirror.gnu.org/units/units-2.00.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/units/units-2.00.tar.gz'
  sha1 '6da9ea78ff0dc21bc43cf1809c530e61d9394ce0'

  def options
    [['--default-names', "Do NOT prepend 'g' to the binary; will override system utils."]]
  end

  def install
    args = ["--prefix=#{prefix}"]
    args << "--program-prefix=g" unless ARGV.include? '--default-names'

    system "./configure", *args
    system "make install"
  end
end
