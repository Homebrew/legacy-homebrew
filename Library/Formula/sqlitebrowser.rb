require 'formula'

class Sqlitebrowser < Formula
  homepage 'http://sqlitebrowser.org'
  url 'https://github.com/sqlitebrowser/sqlitebrowser/archive/v3.3.1.tar.gz'
  sha1 '5d05093d602113b27d594878fcf0d8974fe91d20'

  head 'https://github.com/sqlitebrowser/sqlitebrowser.git'

  bottle do
    cellar :any
    sha1 "b84a47145f9bbf241b280e6ccd4646ba38cb1f7a" => :mavericks
    sha1 "fc8e7173447061f096248e6e468d423a38fd5074" => :mountain_lion
    sha1 "4f2814aa785bd36b5da13226d0da7a67863a3aeb" => :lion
  end

  depends_on 'qt'
  depends_on 'cmake' => :build
  depends_on 'sqlite' => 'with-functions'

  def install
    system "cmake", ".", *std_cmake_args
    system 'make install'
  end
end
