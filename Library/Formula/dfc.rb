require 'formula'

class Dfc < Formula
  homepage 'http://projects.gw-computing.net/projects/dfc'
  url 'http://projects.gw-computing.net/attachments/download/79/dfc-3.0.4.tar.gz'
  sha1 'e3b7fc7474f2ca36c1370a3dcbcd3d1020766f1a'

  depends_on 'cmake' => :build
  depends_on 'gettext'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
