require 'formula'

class Kalzium < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.7.4/src/kalzium-4.7.4.tar.bz2'
  homepage ''
  md5 '73a38220f4b973f45da6134d8b8dcbb7'

  depends_on 'cmake' => :build

  def install
    system "cmake . -DCMAKE_PREFIX_PATH=/usr/local/Cellar/gettext/0.18.1.1/ #{std_cmake_parameters}"
    system "make install"
  end

end
