require "formula"

class NetSnmp < Formula
  homepage "http://www.net-snmp.org/"

  stable do
    url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.7.2.1/net-snmp-5.7.2.1.tar.gz"
    sha1 "815d4e5520a1ed96a27def33e7534b4190599f0f"

    depends_on MaximumMacOSRequirement => :mountain_lion
  end

  bottle do
    sha1 "6f1ff81bde5defe92b4a2062fba099c8310f9662" => :mountain_lion
    sha1 "cfeb129e4130ed17656443efd728ae0812a78720" => :lion
  end

  devel do
    url "https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.7.3-pre-releases/net-snmp-5.7.3.pre3.tar.gz"
    version "5.7.3.pre3"
    sha1 "5e46232a2508a3cb6543f0438569090f78e4a20e"
  end

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

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
