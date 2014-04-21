require 'formula'

class Libmaxminddb < Formula
  homepage 'https://github.com/maxmind/libmaxminddb'
  url 'https://github.com/maxmind/libmaxminddb/releases/download/0.5.3/libmaxminddb-0.5.3.tar.gz'
  sha1 'ce6dd4fecb1a4c97cfede70e6fc6af863ffeddab'

  head do
    url 'https://github.com/maxmind/libmaxminddb.git'

    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
    depends_on 'libtool' => :build
  end

  depends_on 'geoipupdate' => :optional

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./bootstrap" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "curl", "-O", "http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz"
    system "gunzip", "GeoLite2-Country.mmdb.gz"
    system "#{bin}/mmdblookup", "-f", "GeoLite2-Country.mmdb",
                                "-i", "8.8.8.8"
  end
end
