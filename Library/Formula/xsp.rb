class Xsp < Formula
  homepage "https://github.com/mono/xsp"
  url "https://github.com/mono/xsp/archive/3.0.11.tar.gz"
  sha256 "290e302a03396c5cff7eb53dae008e9f79dd00aca15ad1e62865907220483baa"

  depends_on "mono"
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "xsp", "--help"
  end
end
