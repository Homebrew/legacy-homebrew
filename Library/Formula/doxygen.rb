require 'formula'

class Doxygen <Formula
  url 'http://ftp.stack.nl/pub/users/dimitri/doxygen-1.6.2.src.tar.gz'
  homepage 'http://www.doxygen.org/'
  md5 '70260101ef60952cb99484700241c99e'

  def install
    system "./configure", "--prefix", "#{prefix}"
    inreplace "Makefile" do |s|
      # Path of man1 relative to already given prefix
      s.change_make_var! 'MAN1DIR', 'share/man/man1'
    end
    system "make"
    system "make install"
  end
end
