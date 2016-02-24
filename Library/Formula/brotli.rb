class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google."
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v0.3.0.tar.gz"
  sha256 "5d49eb1a6dd19304dd683c293abf66c8a419728f4c6d0f390fa7deb2a39eaae2"

  head "https://github.com/google/brotli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "55d144b12585d2135be9ec4f7880798eabda037e14c48209b4bc7da064407da8" => :el_capitan
    sha256 "380c2852c24248fcbdeb2aa25848b958765131fa7126103603f7603ad1510b9b" => :yosemite
    sha256 "79e2367abe6f3e1958a8857052bd406312fc4db60ce603d594e708bd4dc6bd4a" => :mavericks
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
