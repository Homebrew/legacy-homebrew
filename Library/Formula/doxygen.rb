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
    # Lion compatibility
    inreplace 'qtools/qglobal.h', '#  if (MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_6)', "#  if !defined(MAC_OS_X_VERSION_10_7)\n#       define MAC_OS_X_VERSION_10_7 MAC_OS_X_VERSION_10_6 + 1\n#  endif\n#  if (MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_7)"
    system "make"
    system "make install"
  end
end
