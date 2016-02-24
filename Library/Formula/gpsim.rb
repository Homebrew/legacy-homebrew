class Gpsim < Formula
  desc "Simulator for Microchip's PIC microcontrollers"
  homepage "http://gpsim.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gpsim/gpsim/0.28.0/gpsim-0.28.1.tar.gz"
  sha256 "d8d41fb530630e6df31db89a0ca630038395aed4d07c48859655468ed25658ed"

  head "svn://svn.code.sf.net/p/gpsim/code/trunk"

  bottle do
    cellar :any
    sha256 "ababc6b31ea089e0431904119f4dc8d0a703c4e14b4d78bc420120ecae1293e4" => :el_capitan
    sha256 "78a225eb11338a6699ccdb4c23ad4c1682cfdc34f06cf2c4fbeb571b238b45c9" => :yosemite
    sha256 "dfdf91a9f332b9880ec59934fe661bbc0d50b45d8f7c2cdde888f31bcaac9c40" => :mavericks
    sha256 "2d0cc0cf61b5df08cce8f9795666228487876cfda9045be3e371b6cd15c70bee" => :mountain_lion
  end

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
