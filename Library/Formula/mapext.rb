class Mapext < Formula
  desc "map files from one extension to another via a specified command"
  homepage "http://www.acme.com/software/mapext/"
  url "http://www.acme.com/software/mapext/mapext_10nov1995.tar.gz"
  version "0.0.19951110"
  sha256 "7e7a775effed89111d079d39d98b917bcdd3d678d6f434ec5243f9e1e2b41206"

  def install
    bin.mkpath
    man1.mkpath

    system "make", "all", "install", "BINDIR=#{bin}", "MANDIR=#{man1}"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/mapext 2>&1", 1)
  end
end
