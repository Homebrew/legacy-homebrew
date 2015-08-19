class Weighttp < Formula
  desc "Webserver benchmarking tool that supports multithreading"
  homepage "http://redmine.lighttpd.net/projects/weighttp/wiki"
  url "https://github.com/lighttpd/weighttp/archive/weighttp-0.3.tar.gz"
  sha256 "376e2311af2decb8f6051e4f968d7c0ba92ca60cd563d768beb4868eb9679f45"

  head "git://git.lighttpd.net/weighttp"

  depends_on "libev"

  def install
    system "./waf", "configure"
    system "./waf", "build"
    bin.install "build/default/weighttp"
  end

  test do
    system "#{bin}/weighttp", "-n", "1", "http://redmine.lighttpd.net/projects/weighttp/wiki"
  end
end
