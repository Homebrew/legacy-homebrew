require 'formula'

class Geoipupdate < Formula
  homepage 'https://github.com/maxmind/geoipupdate'
  url 'https://github.com/maxmind/geoipupdate/releases/download/v2.0.0/geoipupdate-2.0.0.tar.gz'
  sha1 'd3c90ad9c9ad5974e8a5a30c504e7827978ddea7'
  head 'https://github.com/maxmind/geoipupdate.git'

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./bootstrap" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/geoipupdate", "-V"
  end
end
