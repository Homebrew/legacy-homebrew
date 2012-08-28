require 'formula'

class LibdbusmenuQt < Formula
  homepage 'https://launchpad.net/libdbusmenu-qt'
  url 'http://launchpad.net/libdbusmenu-qt/trunk/0.9.2/+download/libdbusmenu-qt-0.9.2.tar.bz2'
  sha1 '308cc53a4a1f2db40f8ffbcfc71e987a4839ec45'

  depends_on 'cmake' => :build
  depends_on 'qt'
  depends_on 'qjson'
  depends_on 'doxygen'

  def install
    mkdir 'macbuild' do
      args = std_cmake_args + ['..']
      system "cmake", *args
      system "make install"
    end
  end
end
