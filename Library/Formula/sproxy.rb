class Sproxy < Formula
  desc "HTTP proxy server collecting URLs in a 'siege-friendly' manner"
  homepage "http://www.joedog.org/sproxy-home/"
  url "http://download.joedog.org/sproxy/sproxy-1.02.tar.gz"
  sha256 "29b84ba66112382c948dc8c498a441e5e6d07d2cd5ed3077e388da3525526b72"

  bottle do
    revision 1
    sha1 "76ec93a0851c1d0b7f55f585550079a2273648e1" => :yosemite
    sha1 "cd11be8dd8662f94005f4c787b399cab0eea5f88" => :mavericks
    sha1 "9574960690dd1700496515f35456570fcefaef8a" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
    # Makefile doesn't honor mandir, so move manpages post-install
    share.install prefix+"man"
  end
end
