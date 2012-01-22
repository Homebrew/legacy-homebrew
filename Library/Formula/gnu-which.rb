require 'formula'

class GnuWhich < Formula
  url 'http://ftpmirror.gnu.org/which/which-2.20.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/which/which-2.20.tar.gz'
  homepage 'http://carlo17.home.xs4all.nl/which/'
  md5 '95be0501a466e515422cde4af46b2744'

  def options
    [['--default-names', "Do NOT prepend 'g' to the binary; will override system utils."]]
  end

  def install
    args = ["--prefix=#{prefix}", "--disable-dependency-tracking"]
    args << "--program-prefix=g" unless ARGV.include? '--default-names'

    system "./configure", *args
    system "make install"
  end
end
