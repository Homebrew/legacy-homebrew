class Gpsim < Formula
  homepage "http://gpsim.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gpsim/gpsim/0.28.0/gpsim-0.28.1.tar.gz"
  sha256 "d8d41fb530630e6df31db89a0ca630038395aed4d07c48859655468ed25658ed"

  head "svn://svn.code.sf.net/p/gpsim/code/trunk"

  depends_on "pkg-config" => :build
  depends_on "gputils" => :build
  depends_on "glib"
  depends_on "popt"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-gui",
                          "--disable-shared",
                          "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install"
  end
end
