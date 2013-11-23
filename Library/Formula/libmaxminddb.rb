require 'formula'

class Libmaxminddb < Formula
  homepage 'https://github.com/maxmind/libmaxminddb'
  url 'https://github.com/maxmind/libmaxminddb/releases/download/0.5.2/libmaxminddb-0.5.2.tar.gz'
  sha1 'db7618a97c222cab0a0ba2fb8439abcd1465f10c'

  option :universal

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/mmdblookup", "-f", "./maxmind-db/test-data/MaxMind-DB-test-ipv4-24.mmdb",
                                "-i", "1.1.1.1"
  end
end
