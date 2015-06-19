class Aha < Formula
  desc "ANSI HTML adapter"
  homepage "https://github.com/theZiz/aha"
  url "https://github.com/theZiz/aha/archive/0.4.8.tar.gz"
  sha256 "a1ebbbd5ebc37ccca74dc5f894e3066157e9e77fcdf158bf5587215b8968049c"

  head "https://github.com/theZiz/aha.git"

  bottle do
    cellar :any
    sha1 "93856bbcf2cd6b169f7a21d9b1a242c0bc031c7e" => :yosemite
    sha1 "80a16f10a5c7417916f64e0df12b072baf29ba03" => :mavericks
    sha1 "d756f3be34861bc510e3182cc406e099d857bdf9" => :mountain_lion
  end

  def install
    # install manpages under share/man/
    inreplace "Makefile", "$(PREFIX)/man", "$(PREFIX)/share/man"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    out = pipe_output(bin/"aha", "[35mrain[34mpill[00m")
    assert_match(/color:purple;">rain.*color:blue;">pill/, out)
  end
end
