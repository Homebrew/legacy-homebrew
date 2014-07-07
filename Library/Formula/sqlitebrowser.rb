require 'formula'

class Sqlitebrowser < Formula
  homepage 'http://sqlitebrowser.org'
  url 'https://github.com/sqlitebrowser/sqlitebrowser/archive/sqlb-3.2.0.tar.gz'
  sha256 '2eabb4c0102cb2fabd6bd556ffc40c247a8b317adf518d0601b5ee885ac86e1b'

  head 'https://github.com/sqlitebrowser/sqlitebrowser.git'

  depends_on 'qt'
  depends_on 'cmake' => :build
  depends_on 'sqlite' => 'with-functions'

  def install
    system "cmake", ".", *std_cmake_args
    system 'make install'
  end
end
