require 'formula'

class OxygenIcons < Formula
  url 'http://ftp.kde.org/stable/4.8.0/src/oxygen-icons-4.8.0.tar.bz2'
  homepage 'http://www.oxygen-icons.org/'
  md5 '2ae26ba235f207eb29677637c1d059a7'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
