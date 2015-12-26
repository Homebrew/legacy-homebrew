class Libcello < Formula
  desc "Higher-level programming in C"
  homepage "http://libcello.org/"
  head "https://github.com/orangeduck/libCello.git"
  url "http://libcello.org/static/libCello-1.1.7.tar.gz"
  sha256 "2273fe8257109c2dd19054beecd83ddcc780ec565a1ad02721e24efa74082908"

  bottle do
    cellar :any
    revision 1
    sha256 "99e4284df31d64596818917832663c6ddca528d1cf0dee15a29152261dde7dae" => :yosemite
    sha256 "9f018f1773ca94ce29a5d534dde008ddaa9bf66d8ef2c30d0e341e1fe36bf468" => :mavericks
    sha256 "4730b47efc29ea8896151ec04afc6b3426cb76669bc65d37f3aa33a5e935fa46" => :mountain_lion
  end

  def install
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
