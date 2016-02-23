class Openlldp < Formula
  desc "Provides LLDP service and viewing from the command-line"
  homepage "http://openlldp.sourceforge.net"
  url "https://downloads.sourceforge.net/project/openlldp/openlldp-0.4alpha.tar.gz"
  version "0.4"
  sha256 "266fd0e1a15f237cfb84ae2d225996836774ea3d4c1c2e2be3a2a6927a00f2b1"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/lldpneighbors"
  end
end
