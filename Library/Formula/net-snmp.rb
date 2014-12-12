require "formula"

class NetSnmp < Formula
  homepage "http://www.net-snmp.org/"
  url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.7.3/net-snmp-5.7.3.tar.gz"
  sha1 "97dc25077257680815de44e34128d365c76bd839"

  bottle do
  end

  depends_on "openssl"
  depends_on :python => :optional

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
      "--without-perl-modules",
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
