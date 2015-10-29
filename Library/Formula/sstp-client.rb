class SstpClient < Formula
  desc "SSTP (Microsofts Remote Access Solution for PPP over SSL) client"
  homepage "http://sstp-client.sourceforge.net"
  url "https://downloads.sourceforge.net/project/sstp-client/sstp-client/1.0.10/sstp-client-1.0.10.tar.gz"
  sha256 "5f9084d8544c42c806724a4e70d039d8cb7b0ea06be8ea9cc5120684d4e0d424"

  bottle do
    cellar :any
    sha256 "d70a56f837f32f2ceab2050fc32855428f6c1df368da447491107dd3c80c030b" => :el_capitan
    sha256 "8c4a3b20b2b92a4dfca222ecb3ccf46a1c20c8cdbcdab60fe6907e81f039927b" => :yosemite
    sha256 "5a07e517c449759938b41c886203fed7294667ba3bc185924e26b7d94267a92f" => :mavericks
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
