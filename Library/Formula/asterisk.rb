class Asterisk < Formula
  desc "Toolkit for building communications applications"
  homepage "http://www.asterisk.org/"
  url "http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-13.6.0.tar.gz"
  sha256 "8a01b53c946d092ac561c11b404f68cd328306d0e3b434a7485a11d4b175005a"

  option "with-sample-config", "Install the sample config files.  NOTE. Without this, you won't have any config file."

  depends_on "openssl"
  depends_on "jansson"
  depends_on "spandsp" => :optional

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}"
    system "make", "ASTCFLAGS=-DRONLY=NETSNMP_OLDAPI_RONLY"
    system "make", "install"
    system "make", "samples" if build.with? "sample-config"
  end

  test do
    assert_match /#{version}/, shell_output("#{sbin}/asterisk -V")
  end
end
