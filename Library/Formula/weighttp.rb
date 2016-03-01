class Weighttp < Formula
  desc "Webserver benchmarking tool that supports multithreading"
  homepage "https://redmine.lighttpd.net/projects/weighttp/wiki"
  url "https://github.com/lighttpd/weighttp/archive/weighttp-0.3.tar.gz"
  sha256 "376e2311af2decb8f6051e4f968d7c0ba92ca60cd563d768beb4868eb9679f45"

  head "https://git.lighttpd.net/weighttp.git"

  bottle do
    cellar :any
    sha256 "780fcf598211fddb69395f7836cf9abb9fd79f57bbd003eca3530b6e73f40646" => :el_capitan
    sha256 "38db09ba5004c81b26a23722c34ce2db054dd680e2e0478e86357389f85a11eb" => :yosemite
    sha256 "0ad4b1d507dc011b9e0dc3410771af9ecab322b4fe7c98121b6266c613360eb3" => :mavericks
  end

  depends_on "libev"

  def install
    system "./waf", "configure"
    system "./waf", "build"
    bin.install "build/default/weighttp"
  end

  test do
    # Stick with HTTP to avoid 'error: no ssl support yet'
    system "#{bin}/weighttp", "-n", "1", "http://redmine.lighttpd.net/projects/weighttp/wiki"
  end
end
