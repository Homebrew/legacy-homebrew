require 'formula'

class Doxygen <Formula
  url 'http://ftp.stack.nl/pub/users/dimitri/doxygen-1.7.1.src.tar.gz'
  homepage 'http://www.doxygen.org/'
  md5 '13e76e10fb55581a16ee04de35c264f0'

  def install
    system "./configure", "--prefix", prefix
    inreplace "Makefile" do |s|
      # Path of man1 relative to already given prefix
      s.change_make_var! 'MAN1DIR', man1
    end
    system "make"
    system "make install"
  end
end
