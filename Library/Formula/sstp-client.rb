class SstpClient < Formula
  desc "SSTP (Microsofts Remote Access Solution for PPP over SSL) client"
  homepage "http://sstp-client.sourceforge.net"
  url "https://downloads.sourceforge.net/project/sstp-client/sstp-client/1.0.10/sstp-client-1.0.10.tar.gz"
  sha256 "5f9084d8544c42c806724a4e70d039d8cb7b0ea06be8ea9cc5120684d4e0d424"

  bottle do
    cellar :any
    sha1 "844e03c512067d1f378acd6af678654915882edd" => :yosemite
    sha1 "d8f68257b54af08c4942a60892c36616a8f03a05" => :mavericks
    sha1 "0984d3b9beed2cf92a47218bfb43bf4ff3b606b1" => :mountain_lion
  end

  depends_on "pkg-config" => :build
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
    (var/"run/sstpc").mkpath
  end

  def caveats; <<-EOS.undent
    sstpc reads PPP configuration options from /etc/ppp/options. If this file
    does not exist yet, type the following command to create it:

    sudo touch /etc/ppp/options
    EOS
  end

  test do
    system "#{sbin}/sstpc", "--version"
  end
end
