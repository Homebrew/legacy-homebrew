require "formula"

class Bzip2 < Formula
  homepage "http://www.bzip.org/downloads.html"
  url "http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz"
  sha1 "3f89f861209ce81a6bab1fd1998c0ef311712002"

  def install
    system "make", "install", "PREFIX=#{prefix}"

    if OS.linux?
      # Install the shared library.
      system "make", "-f", "Makefile-libbz2_so", "clean"
      system "make", "-f", "Makefile-libbz2_so"
      lib.install "libbz2.so.1.0.6", "libbz2.so.1.0"
      lib.install_symlink "libbz2.so.1.0.6" => "libbz2.so.1"
      lib.install_symlink "libbz2.so.1.0.6" => "libbz2.so"
    end
  end

  test do
    system "#{bin}/bzip2 --version"
  end
end
