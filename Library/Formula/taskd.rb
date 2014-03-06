require "formula"

class Taskd < Formula
  homepage "http://taskwarrior.org/projects/show/taskwarrior"
  url "http://www.taskwarrior.org/download/taskd-1.0.0.tar.gz"
  sha1 "5a89406a21be1f95ece03674315b35814fe4f037"
  revision 1

  head 'git://tasktools.org/taskd.git'

  depends_on "cmake" => :build
  depends_on "gnutls"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/taskd", "init", '--data', testpath
  end
end
