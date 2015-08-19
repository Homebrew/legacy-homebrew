class NetSnmp < Formula
  desc "Implements SNMP v1, v2c, and v3, using IPv4 and IPv6"
  homepage "http://www.net-snmp.org/"
  url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.7.3/net-snmp-5.7.3.tar.gz"
  sha256 "12ef89613c7707dc96d13335f153c1921efc9d61d3708ef09f3fc4a7014fb4f0"

  bottle do
    revision 1
    sha256 "a6f767019c8a1909d549bb20e10481bb118b57d5fd3c4c649a3045ba332befbb" => :yosemite
    sha256 "07068a85e19404c68df7fffa931a6f9a9f2230c6b53900ee27db233c2e6e1aea" => :mavericks
    sha256 "8a031267a4188944dae2de51ab71f88b5b79f12dd533ad579b5bca4d7849943d" => :mountain_lion
  end

  depends_on "openssl"
  depends_on :python => :optional

  keg_only :provided_by_osx

  def install
    args = [
      "--disable-debugging",
      "--prefix=#{prefix}",
      "--enable-ipv6",
      "--with-defaults",
      "--with-persistent-directory=#{var}/db/net-snmp",
      "--with-logfile=#{var}/log/snmpd.log",
      "--with-mib-modules=host ucd-snmp/diskio",
      "--without-rpm",
      "--without-kmem-usage",
      "--disable-embedded-perl",
      "--without-perl-modules"
    ]

    if build.with? "python"
      args << "--with-python-modules"
      ENV["PYTHONPROG"] = `which python`
    end

    # https://sourceforge.net/p/net-snmp/bugs/2504/
    ln_s "darwin13.h", "include/net-snmp/system/darwin14.h"

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
