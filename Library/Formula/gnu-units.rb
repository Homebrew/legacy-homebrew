require 'formula'

class GnuUnits < Formula
  url 'http://ftp.gnu.org/gnu/units/units-1.88.tar.gz'
  homepage 'http://www.gnu.org/software/units/'
  md5 '9b2ee6e7e0e9c62741944cf33fc8a656'

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
