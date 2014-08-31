require 'formula'

class Sqlitebrowser < Formula
  homepage 'http://sqlitebrowser.org'
  url 'https://github.com/sqlitebrowser/sqlitebrowser/archive/v3.3.1.tar.gz'
  sha1 '5d05093d602113b27d594878fcf0d8974fe91d20'

  head 'https://github.com/sqlitebrowser/sqlitebrowser.git'

  bottle do
    cellar :any
    sha1 "750444aa3b7f137641c34d9bc69610bb1eca74ed" => :mavericks
    sha1 "29dfedf65d80f50f2a3586a0a4e9e3e40a261b86" => :mountain_lion
    sha1 "ea3855b388a381a7cf281b1155841df9aa02c687" => :lion
  end

  depends_on 'qt'
  depends_on 'cmake' => :build
  depends_on 'sqlite' => 'with-functions'

  def install
    system "cmake", ".", *std_cmake_args
    system 'make install'
  end
end
