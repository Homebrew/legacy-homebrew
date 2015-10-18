class Ncp < Formula
  desc "File copy tool for LANs"
  homepage "http://www.fefe.de/ncp/"
  url "http://dl.fefe.de/ncp-1.2.4.tar.bz2"
  sha256 "6cfa72edd5f7717bf7a4a93ccc74c4abd89892360e2e0bb095a73c24b9359b88"
  head ":pserver:cvs:@cvs.fefe.de:/cvs", :using => :cvs

  depends_on "libowfat"

  # fixes man and libowfat paths and "strip" command in Makefile
  patch do
    url "https://gist.githubusercontent.com/plumbojumbo/9331146/raw/560e46a688ac9493ffbc1464e59cc062c0940532/GNUmakefile.diff"
    sha256 "b269c3a024583918d2279324660f467060f0c2adb57db31c19c05f7bbd958b19"
  end

  def install
    system "make", "CC=#{ENV.cc}",
                   "LIBOWFAT_PREFIX=#{Formula["libowfat"].opt_prefix}"
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
