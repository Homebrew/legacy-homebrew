require 'formula'

class Findutils <Formula
  url 'http://ftp.gnu.org/pub/gnu/findutils/findutils-4.4.2.tar.gz'
  homepage 'http://www.gnu.org/software/findutils/'
  md5 '351cc4adb07d54877fa15f75fb77d39f'

  def options
    [['--default-names', "Do NOT prepend 'g' to the binary; will override system utils."]]
  end

  def install
    args = ["--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"]
    args << "--program-prefix=g" unless ARGV.include? '--default-names'

    system "./configure", *args
    system "make install"
  end
end
