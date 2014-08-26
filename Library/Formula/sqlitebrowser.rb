require 'formula'

class Sqlitebrowser < Formula
  homepage 'http://sqlitebrowser.org'
  url 'https://github.com/sqlitebrowser/sqlitebrowser/archive/v3.3.0.tar.gz'
  sha1 '9585fd37465b844d5458152883b6305c6e3e8530'

  head 'https://github.com/sqlitebrowser/sqlitebrowser.git'

  depends_on 'qt'
  depends_on 'cmake' => :build
  depends_on 'sqlite' => 'with-functions'

  def install
    system "cmake", ".", *std_cmake_args
    system 'make install'
  end
end
