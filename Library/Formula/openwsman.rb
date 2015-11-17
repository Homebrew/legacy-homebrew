class Openwsman < Formula
  desc "Implementation of WS-Management, enabling in-band resource management"
  homepage "https://openwsman.github.io"
  url "https://github.com/Openwsman/openwsman/archive/v2.6.0.tar.gz"
  sha256 "449b4972dc7700918f8f674047f0a1a9c19eeee3f4ce82f47890dddfa56e823f"
  revision 1

  bottle do
    sha256 "e6e5675c6163c2e58811571e82f2e016563718aeabeca7abc30dcc055be0396e" => :yosemite
    sha256 "134ab348c9a14fde95d021b77fcf265edc19e6697e3f4b336bf47e4b3d7822d0" => :mavericks
    sha256 "4626e6f4c61e3c01a442d19c0246eb149ba5e280f66b1b046e0cb9362ef5c322" => :mountain_lion
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
