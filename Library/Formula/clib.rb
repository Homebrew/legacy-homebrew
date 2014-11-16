require "formula"

class Clib < Formula
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.2.3.tar.gz"
  sha1 "15f75a9eee1adee29c091b68c1dcb2e05361b665"

  bottle do
    cellar :any
    sha1 "32b3695b5757396d7f32ec5ab88da32aa21d9169" => :yosemite
    sha1 "e59ef5a602376d6c4d9c47dd4d1b11e956d53a2b" => :mavericks
    sha1 "1a883182f9f9dad2cad59985193fceb714f03fae" => :mountain_lion
  end

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
