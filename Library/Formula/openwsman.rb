class Openwsman < Formula
  desc "Implementation of WS-Management, enabling in-band resource management"
  homepage "https://openwsman.github.io"
  url "https://github.com/Openwsman/openwsman/archive/v2.6.2.tar.gz"
  sha256 "9c28e613bf3fd3b9b9b1cd484099d339c713a997a322b069a80b3be1465dd3a1"

  bottle do
    sha256 "32dfb7f453e6473e17dbc641ed6ed2b97be424b1b1bc6e3bbb458a8d483969b3" => :el_capitan
    sha256 "4876db5b282be5be45512e19eb0a3c9a23450fd88dfe7ba0fcdddfe8bfe01c1d" => :yosemite
    sha256 "dd98edf8d15ddaeab16c779cbc2d9ecb6a6c5c246d143789b8e79b03bbbb37e0" => :mavericks
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on "sblim-sfcc"
  depends_on "openssl"

  def install
    system "./autoconfiscate.sh"
    system "./configure", "--disable-more-warnings",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    (testpath/"openwsman.conf").write <<-EOS.undent
      [server]
      # conf file based on https://raw.githubusercontent.com/Openwsman/openwsman/master/etc/openwsman.conf

      port = 5985

      ipv4 = yes
      ipv6 = yes
      ssl_disabled_protocols = SSLv2 SSLv3

      min_threads = 4
      max_threads = 0

      basic_authenticator = libwsman_pam_auth.dylib
      basic_authenticator_arg = openwsman


      [cim]
      default_cim_namespace = root/cimv2
      cim_client_frontend = XML
      vendor_namespaces = OpenWBEM=http://schema.openwbem.org/wbem/wscim/1/cim-schema/2,Linux=http://sblim.sf.net/wbem/wscim/1/cim-schema/2,OMC=http://schema.omc-project.org/wbem/wscim/1/cim-schema/2,PG=http://schema.openpegasus.org/wbem/wscim/1/cim-schema/2,RCP=http://schema.suse.com/wbem/wscim/1/cim-schema/2,DCIM=http://schemas.dell.com/wbem/wscim/1/cim-schema/2,SPAR=http://schema.unisys.com/wbem/wscim/1/cim-schema/2,SVS=http://schemas.ts.fujitsu.com/wbem/wscim/1/cim-schema/2
      port = 5989
      ssl = yes
      verify_cert = no
    EOS

    # should be able to open and parse the a config file
    system "#{sbin}/openwsmand", "--config-file=#{testpath}/openwsman.conf"
  end
end
