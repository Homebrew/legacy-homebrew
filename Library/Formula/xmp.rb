class Xmp < Formula
  desc "Command-line player for module music formats (MOD, S3M, IT, etc)"
  homepage "http://xmp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/xmp/xmp/4.0.10/xmp-4.0.10.tar.gz"
  sha256 "b6d45fef0dbdb4ad4948b9f82335cbfaf60eaec3a63cc9a0050a1e5cf7a65e3e"

  bottle do
    sha256 "30123b45264d818a74c8a47171b984dbce47ba1342bada039405882f2bb906e2" => :yosemite
    sha256 "39c8747c8f8cb4a61b7050cca33f2e58b4e96c669cd194253a673ea53a27d609" => :mavericks
    sha256 "7c0ceac5687e8e6ee8da0cd9ac35e91061919ed932ec681f79bf25a2e8493e7c" => :mountain_lion
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
