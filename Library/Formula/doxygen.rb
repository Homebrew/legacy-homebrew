require 'formula'

class Doxygen <Formula
  url 'http://ftp.stack.nl/pub/users/dimitri/doxygen-1.6.3.src.tar.gz'
  homepage 'http://www.doxygen.org/'
  md5 '2d6ea20a9d850d94321cee78bab7bb87'

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
