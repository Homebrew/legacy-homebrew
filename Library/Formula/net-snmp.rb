class NetSnmp < Formula
  desc "Implements SNMP v1, v2c, and v3, using IPv4 and IPv6"
  homepage "http://www.net-snmp.org/"
  url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.7.3/net-snmp-5.7.3.tar.gz"
  sha256 "12ef89613c7707dc96d13335f153c1921efc9d61d3708ef09f3fc4a7014fb4f0"

  bottle do
    revision 2
    sha256 "92956eecd7dcaa9743527af24d68d52c772555c3f512f10d773aa6083a1e3290" => :yosemite
    sha256 "3c045453d9c666ec873b90477b1efe10d5c8583994b65666e3d445eb2e5670c8" => :mavericks
    sha256 "f2c4102f61ee8d6ad151bdbe6da97a5fc5127e84e7939f5e1672f81414a28873" => :mountain_lion
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
    ln_s "darwin13.h", "include/net-snmp/system/darwin15.h"

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
