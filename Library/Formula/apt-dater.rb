require 'formula'

class AptDater < Formula
  homepage 'http://www.ibh.de/apt-dater/'
  url 'https://downloads.sourceforge.net/project/apt-dater/apt-dater/0.9.0/apt-dater-0.9.0.tar.gz'
  sha1 'f62fe55602f2526f2830c3c266b8c392bb908d92'

  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'popt'

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
