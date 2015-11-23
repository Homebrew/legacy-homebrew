class Libcello < Formula
  desc "Higher-level programming in C"
  homepage "http://libcello.org/"
  head "https://github.com/orangeduck/libCello.git"
  url "http://libcello.org/static/libCello-1.1.7.tar.gz"
  sha256 "2273fe8257109c2dd19054beecd83ddcc780ec565a1ad02721e24efa74082908"

  bottle do
    cellar :any
    revision 1
    sha1 "d208cfa93fcd658a225dd46b0eba986f9a30e474" => :yosemite
    sha1 "f95afa9fb94b09e9c2102932792288fc2352d091" => :mavericks
    sha1 "507985cc79584569e6c04dfb9b9772a97573b2a9" => :mountain_lion
  end

  def install
    system "make", "check"
    system "make", "install", "PREFIX=#{prefix}"
  end
end
