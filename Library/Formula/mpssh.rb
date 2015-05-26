class Mpssh < Formula
  homepage "https://github.com/ndenev/mpssh"
  url "https://github.com/ndenev/mpssh/archive/1.3.3.tar.gz"
  sha1 "ba11dfe7607cac3d47f1c86db236a2e440700ce7"
  head "https://github.com/ndenev/mpssh.git"

  bottle do
    cellar :any
    sha1 "3f673d4d3e00110be048b3a18c876ec8e9ccab2f" => :yosemite
    sha1 "5ad290e9a62712e43a2b624c2d9e73b1b2d445e7" => :mavericks
    sha1 "86902eb4b59dbf70f41fc8a7c9dabc3b30e5e140" => :mountain_lion
  end

  stable do
    patch do
      # don't install binaries as root (upstream PR merged in HEAD)
      url "https://github.com/bfontaine/mpssh/commit/3cbb868b6fdf8dff9ab86868510c0455ad1ec1b3.diff"
      sha1 "745b6d07bc479a2d4d64d71904342d76c52fa8ab"
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
