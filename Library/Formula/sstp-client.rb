class SstpClient < Formula
  desc "SSTP (Microsofts Remote Access Solution for PPP over SSL) client"
  homepage "http://sstp-client.sourceforge.net"
  url "https://downloads.sourceforge.net/project/sstp-client/sstp-client/1.0.9/sstp-client-1.0.9.tar.gz"
  sha256 "d3d8a26485b2cf0b24e148301b94b3ab9cdb17700ecd7c408b8fd6ad16f7fc4e"
  revision 1

  bottle do
    cellar :any
    sha1 "844e03c512067d1f378acd6af678654915882edd" => :yosemite
    sha1 "d8f68257b54af08c4942a60892c36616a8f03a05" => :mavericks
    sha1 "0984d3b9beed2cf92a47218bfb43bf4ff3b606b1" => :mountain_lion
  end

  depends_on "libevent"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-ppp-plugin",
                          "--prefix=#{prefix}",
                          "--with-runtime-dir=#{var}/run/sstpc"

    system "make", "install"

    # Create a directory needed by sstpc for privilege separation
    mkdir_p var/"run/sstpc"
  end

  def caveats; <<-EOS.undent
    sstpc reads PPP configuration options from /etc/ppp/options. If this file
    does not exist yet, type the following command to create it:

    sudo touch /etc/ppp/options
    EOS
  end

  test do
    # I know it's a bad test, but I have no idea how to test a VPN client
    # more thoroughly without trying to connect to an actual VPN server
    system "#{sbin}/sstpc", "--version"
  end
end
