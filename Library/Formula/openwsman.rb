class Openwsman < Formula
  desc "Implementation of WS-Management, enabling in-band resource management"
  homepage "https://openwsman.github.io"
  url "https://github.com/Openwsman/openwsman/archive/v2.5.0.tar.gz"
  sha256 "538ad011c3be59ed9843f8499ce749b98cc245208f7b3ca9ca9d53611fee7fe5"

  bottle do
    sha256 "8cd55e679f4ffca631ae1a7d86b4e9c70ee4c85d82dc5b4c7429030d0ded85ea" => :yosemite
    sha256 "47e118663639ee25428730217e78df51cc7ccfdc9c50648a7d8d0b87460f5b43" => :mavericks
    sha256 "aeadefecb859c12ad6d95ee42724be21a81e5ce28611b23e3dfa96efb2bfead9" => :mountain_lion
  end

  depends_on "libxml2"
  depends_on "sblim-sfcc"
  depends_on "automake"   => :build
  depends_on "autoconf"   => :build
  depends_on "libtool"    => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"

  def install
    system "./autoconfiscate.sh"
    system "./configure", "--disable-more-warnings",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
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
