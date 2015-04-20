require 'formula'

class Sqlitebrowser < Formula
  homepage 'http://sqlitebrowser.org'
  url 'https://github.com/sqlitebrowser/sqlitebrowser/archive/v3.5.1.tar.gz'
  sha1 '2c915ccb1e869e98c9e4133ecef1ba003a304d87'

  head 'https://github.com/sqlitebrowser/sqlitebrowser.git'

  bottle do
    cellar :any
    sha1 "34109839c79ae06a811db806782433c193ba99f6" => :yosemite
    sha1 "82ae0afbb0fac9c67e25b6d8d55007dc7371bdf1" => :mavericks
    sha1 "c4af5c9aa9fd484beabc8726eeab13ae1dd15f72" => :mountain_lion
  end

  depends_on 'qt'
  depends_on 'cmake' => :build
  depends_on 'sqlite' => 'with-functions'

  def install
    system "cmake", ".", *std_cmake_args
    system 'make install'
  end
end
