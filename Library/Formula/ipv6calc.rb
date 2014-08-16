require "formula"

class Ipv6calc < Formula
  homepage 'http://www.deepspace6.net/projects/ipv6calc.html'
  url 'ftp://ftp.bieringer.de/pub/linux/IPv6/ipv6calc/ipv6calc-0.97.4.tar.gz'
  mirror 'ftp://ftp.deepspace6.net/pub/ds6/sources/ipv6calc/ipv6calc-0.97.4.tar.gz'
  sha1 '835f73db9309ca9bc3970ece5347ebb331b9f63f'

  depends_on 'geoip' => :optional

  def install
    inreplace 'databases/lib/Makefile.in', "-Wl,-soname,", "-Wl,-install_name,"
    inreplace 'lib/Makefile.in', "-Wl,-soname,", "-Wl,-install_name,"
    # This needs --mandir, otherwise it tries to install to /share/man/man8.
    inreplace 'man/Makefile.in', "$(mandir)/man8", "${PREFIX}/man/man8"

    args = ["--prefix=#{prefix}",
            "--enable-geoip", "--with-geoip-dynamic",
            "--with-geoip-ipv6-compat",
            "--enable-ip2location", "--with-ip2location-dynamic",
            "--with-ip2location-headers-fallback"]

    if build.with? 'geoip'
      args << "--with-geoip-lib=#{Formula["geoip"].opt_prefix}/lib" <<
       "--with-geoip-headers=#{Formula["geoip"].opt_prefix}/include" <<
       "--with-geoip-db=#{var}/GeoIP"
    else
      args << "--with-geoip-headers-fallback"
    end

    system "./configure", *args
    system "make", "test"
    system "make install"
  end

  test do
    # IPv4 address contained in a 6to4 IPv6 address and revert
    system "#{bin}/ipv6calc",
      "-q --action conv6to4 --in ipv6 2002:c0a8:fb61::1 --out ipv4"
    system "#{bin}/ipv6calc",
      "-q --action conv6to4 --in ipv4 192.168.251.97 --out ipv6"
    # Information about a simple IPv6 address
    system "#{bin}/ipv6calc",
      "-q -i 3ffe:ffff::210:a4ff:fe01:2345"
    # Information about a Teredo IPv6 address
    system "#{bin}/ipv6calc",
      "-q -i 3ffe:831f:ce49:7601:8000:efff:af4a:86BF"
    # machine readable output, IP2Location and/or GeoIP information
    system "#{bin}/ipv6calc",
      "-q -i -m 2a01:238:423d:8800:85b3:9e6b:3019:8909"
  end
end
