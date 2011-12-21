require 'formula'

class Attica < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/attica/attica-0.2.9.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 '7dadb6ca7dec09f89d41cd868ea6dc39'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
