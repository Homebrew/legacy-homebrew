require "formula"

class ClangFormat < Formula
  homepage "http://llvm.org/releases/download.html"
  url "http://llvm.org/releases/3.4/clang+llvm-3.4-x86_64-apple-darwin10.9.tar.gz"
  sha1 "4b7a4fbabffc1bda669f7ff961ab072ffc467fed"

  def install
    bin.install('bin/clang-format')
  end

  test do
    system "#{bin}/clang-format", "-version"
  end
end
