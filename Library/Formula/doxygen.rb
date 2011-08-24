require 'formula'

class Doxygen < Formula
  url 'http://ftp.stack.nl/pub/users/dimitri/doxygen-1.7.4.src.tar.gz'
  homepage 'http://www.doxygen.org/'
  md5 'ff908759ff7cd9464424b04ae6c68e48'
  head 'https://doxygen.svn.sourceforge.net/svnroot/doxygen/trunk'

  def install
    system "./configure", "--prefix", prefix
    inreplace "Makefile" do |s|
      # Path of man1 relative to already given prefix
      s.change_make_var! 'MAN1DIR', 'share/man/man1'
    end

    # This allows compilation against 10.7 Lion, by changing a preprocessor
    # OS version check error to a warning. A bug report has been filed
    # upstream (https://bugzilla.gnome.org/show_bug.cgi?id=650463). This
    # should be fixed in the next version of Doxygen, so the following line
    # can and should be removed when it is released.
    inreplace "qtools/qglobal.h", "    error", "    warning"

    system "make"
    system "make install"
  end
end
