require "formula"

class Tcpreplay < Formula
  homepage "http://tcpreplay.appneta.com"
  url "https://github.com/appneta/tcpreplay/releases/download/v4.0.5/tcpreplay-4.0.5.tar.gz"
  sha1 "878970d77e1482c9b26ac19eb2d125915a900f9b"

  bottle do
    cellar :any
    revision 1
    sha1 "41ac901cbb00f327c68d6bdcfd0ff635d889b307" => :yosemite
    sha1 "c248e2ef79aab230d8e8e1f5ee73194725adf496" => :mavericks
    sha1 "cf7683e9724b917bbf24bfa27985a0ade9c26670" => :mountain_lion
  end

  depends_on "libdnet" => :recommended

  devel do
    url "https://github.com/appneta/tcpreplay/releases/download/v4.1.0beta2/tcpreplay-4.1.0beta2.tar.gz"
    sha1 "63c2e5cb17e65bd5072661b43553dc7efc48e881"
    version "4.1.0-b2"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-dynamic-link",
                          "--with-libpcap=#{MacOS.sdk_path}/usr"
    system "make", "install"
  end

  test do
    system "#{bin}/tcpreplay", "--version"
  end
end
