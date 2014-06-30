require "formula"

class Ncp < Formula
  homepage "http://www.fefe.de/ncp/"
  url "http://dl.fefe.de/ncp-1.2.4.tar.bz2"
  sha1 "bd33e5311c249948559d17bfd59df93ae72e1f17"
  head "cvs://:pserver:cvs:@cvs.fefe.de:/cvs:ncp"

  depends_on "libowfat"

  # fixes man and libowfat paths and "strip" command in Makefile
  patch do
    url "https://gist.githubusercontent.com/plumbojumbo/9331146/raw/560e46a688ac9493ffbc1464e59cc062c0940532/GNUmakefile.diff"
    sha1 "2c187e6c6bfd87b08c9573f97b0d220228d2e14e"
  end

  def install
    system "make", "CC=#{ENV.cc}",
                   "LIBOWFAT_PREFIX=#{Formula['libowfat'].opt_prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    ping = "Hello, brew!\n"
    pong = ""
    IO.popen("#{bin}/npush -b 2>/dev/null", "r+") do |push|
      push.puts ping
      push.close_write
      IO.popen("#{bin}/npoll 127.0.0.1 2>/dev/null", "r") do |poll|
        pong = poll.gets
      end
    end
    assert_equal ping, pong
  end
end
