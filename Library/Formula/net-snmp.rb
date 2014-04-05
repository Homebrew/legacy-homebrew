require 'formula'

class NetSnmp < Formula
  homepage 'http://www.net-snmp.org/'
  url 'https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.7.2/net-snmp-5.7.2.tar.gz'
  sha1 'c493027907f32400648244d81117a126aecd27ee'
  
  depends_on :python => :optional

  devel do
    url 'https://downloads.sourceforge.net/project/net-snmp/net-snmp/5.7.3-pre-releases/net-snmp-5.7.3.pre1.tar.gz'
    version '5.7.3.pre1'
    sha1 '3420d54a8e78e460c8900bd752b91687fcba7b80'
  end

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
    
    if build.with? 'python'
      args << "--with-python-modules"
      # the net-snmp configure script finds the wrong python
      ENV['PYTHONPROG'] = "#{bin}/python"
    end
    
    system "./configure", *args
    system "make"
    system "make install"
  end
end
