class AptDater < Formula
  desc "Manage package updates on remote hosts using SSH"
  homepage "https://www.ibh.de/apt-dater/"
  url "https://downloads.sourceforge.net/project/apt-dater/apt-dater/0.9.0/apt-dater-0.9.0.tar.gz"
  sha256 "10b8335c156dabae249aa071cf8689900fae325c2e9540e36a840a2a77d3eeb4"

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "popt"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "AM_LDFLAGS=", "install"
  end

  test do
    system "#{bin}/apt-dater", "-v"
  end
end
