class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google."
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v0.3.0.tar.gz"
  sha256 "5d49eb1a6dd19304dd683c293abf66c8a419728f4c6d0f390fa7deb2a39eaae2"

  head "https://github.com/google/brotli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb883283303c6689c5f7ecc26a66d1591b5aaa2919b3f243b0da880f33f8871a" => :el_capitan
    sha256 "fca2a2933a4f4b5d4e81dbcb6b6b2ae38ea72b26c3d2d1666f70a95f74048d63" => :yosemite
    sha256 "025ba928b046520276d955178429a894d4e3b6fb1917cc49f2a4486a5b1a28a3" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  conflicts_with "bro", :because => "Both install a `bro` binary"

  def install
    system "make", "-C", "tools"
    bin.install "tools/bro" => "bro"
  end

  test do
    (testpath/"file.txt").write("Hello, World!")
    system "#{bin}/bro", "--input", "file.txt", "--output", "file.txt.br"
    system "#{bin}/bro", "--input", "file.txt.br", "--output", "out.txt", "--decompress"
    assert_equal (testpath/"file.txt").read, (testpath/"out.txt").read
  end
end
