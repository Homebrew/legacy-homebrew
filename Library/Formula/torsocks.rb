class Torsocks < Formula
  desc "Use SOCKS-friendly applications with Tor"
  homepage "https://gitweb.torproject.org/torsocks.git/"
  url "https://git.torproject.org/torsocks.git",
    :tag => "v2.0.0",
    :revision => "ea105bb76ea1e9f9660dd2307639b75ca6d76569"

  head "https://git.torproject.org/torsocks.git"

  bottle do
    sha1 "75a53b9a12c5f3b1dbcdfd659f9bdecf6703a2f8" => :yosemite
    sha1 "02573816190ad4fa6ee829e59b293224a90b6dad" => :mavericks
    sha1 "d10034aa108b8a4baf2a6ecd73457cf279681eb3" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/torsocks", "--help"
  end
end
