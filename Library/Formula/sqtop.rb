class Sqtop < Formula
  desc "Display information about active connections for a Squid proxy"
  homepage "https://github.com/paleg/sqtop"
  url "https://github.com/paleg/sqtop/archive/v2015-02-08.tar.gz"
  version "2015-02-08"
  sha1 "379a97e0190f3da39e2d67096955c40217b39ae5"

  bottle do
    cellar :any
    sha1 "2200c1623c2cb8d8214fc5ea34e3942fc55cc7df" => :yosemite
    sha1 "f7d5f09979a76de5f3edd77b9ced98d03aff5954" => :mavericks
    sha1 "4a092176469214d7f45f7502701165cb5ccdc140" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "#{version}", shell_output("#{bin}/sqtop --help")
  end
end
