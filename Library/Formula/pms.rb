class Pms < Formula
  homepage "http://pms.sourceforge.net"
  url "https://downloads.sourceforge.net/project/pms/pms/0.42/pms-0.42.tar.bz2"
  sha256 "96bf942b08cba10ee891a63eeccad307fd082ef3bd20be879f189e1959e775a6"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match(/Practical Music Search v#{version}/,
                 shell_output("#{bin}/pms -?", 4))
  end
end
