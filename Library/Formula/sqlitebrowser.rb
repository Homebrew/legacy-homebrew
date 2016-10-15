require 'formula'

class Sqlitebrowser < Formula
  homepage 'http://sqlitebrowser.org'
  url 'https://github.com/sqlitebrowser/sqlitebrowser/archive/sqlb-3.1.0.tar.gz'
  sha256 '06ba56016c1f39935d8e121304e27d4d55b0bc74181e4b20155c11aa8c183aae'

  head 'https://github.com/sqlitebrowser/sqlitebrowser.git'

  depends_on 'qt'
  depends_on 'cmake' => :build
  depends_on 'sqlite' => '--with-functions'

  def install
    system "cmake", ".", *std_cmake_args
    system 'make install'
  end
end
