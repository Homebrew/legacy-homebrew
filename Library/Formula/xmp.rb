class Xmp < Formula
  desc "Command-line player for module music formats (MOD, S3M, IT, etc)"
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/xmp/4.0.11/xmp-4.0.11.tar.gz"
  sha256 "ba09beefb9bc67cd01bba96e6c79c4896f9d99161ea41ddbfee0e25db09e7991"

  bottle do
    sha256 "0bc782b665dae4b64def3b78e59fa4ca4389f3afba0ab115d5ca707853d53b60" => :el_capitan
    sha256 "c5d55ea6d90ddfafc9b9268a6c1af3e8f14f427ac65fd3109ad2de1611c7afdb" => :yosemite
    sha256 "ceac113907bd3ab2d2b8507346ead946d44ad3d174355df8815f7c90fd0b04b5" => :mavericks
  end

  head do
    url "git://git.code.sf.net/p/xmp/xmp-cli"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool"  => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libxmp"

  def install
    if build.head?
      system "glibtoolize"
      system "aclocal"
      system "autoconf"
      system "automake", "--add-missing"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
