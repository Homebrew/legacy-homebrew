class Openwsman < Formula
  desc "Implementation of WS-Management, enabling in-band resource management"
  homepage "https://openwsman.github.io"
  url "https://github.com/Openwsman/openwsman/archive/v2.6.0.tar.gz"
  sha256 "449b4972dc7700918f8f674047f0a1a9c19eeee3f4ce82f47890dddfa56e823f"

  bottle do
    sha256 "8a0fd930fef9bd3c27d87aba598559e40d2c8d1d9d13971b356e77f395766e27" => :yosemite
    sha256 "1eeb394c2902d5b9b111cdca6e2e07e80e6db93acc33a9050a607ecf4385148e" => :mavericks
    sha256 "02576b4069a7238f8d65eb16124cdf0f731c14be3968a1e40ff7f981880a2451" => :mountain_lion
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
