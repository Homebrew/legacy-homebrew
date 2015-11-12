class Mpssh < Formula
  desc "Mass parallel ssh"
  homepage "https://github.com/ndenev/mpssh"
  url "https://github.com/ndenev/mpssh/archive/1.3.3.tar.gz"
  sha256 "510e11c3e177a31c1052c8b4ec06357c147648c86411ac3ed4ac814d0d927f2f"
  head "https://github.com/ndenev/mpssh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e5ac485861dfca0be2bb1ca2eb5826b5ca5977c0d2abb12dc58de011c18046f1" => :el_capitan
    sha1 "3f673d4d3e00110be048b3a18c876ec8e9ccab2f" => :yosemite
    sha1 "5ad290e9a62712e43a2b624c2d9e73b1b2d445e7" => :mavericks
    sha1 "86902eb4b59dbf70f41fc8a7c9dabc3b30e5e140" => :mountain_lion
  end

  stable do
    patch do
      # don't install binaries as root (upstream commit)
      url "https://github.com/ndenev/mpssh/commit/3cbb868b6fdf8dff9ab86868510c0455ad1ec1b3.diff"
      sha256 "f5df424a91df1f427f96cd482d0bc22cfd90ac25c9e6beb8ca029f3a1038c3de"
    end
  end

  def install
    system "make", "install", "CC=#{ENV.cc}", "BIN=#{bin}"
    man1.install "mpssh.1"
  end

  test do
    system "#{bin}/mpssh"
  end
end
