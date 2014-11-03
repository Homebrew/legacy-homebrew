require "formula"

class Nzbget < Formula
  homepage "http://nzbget.net/"
  url "https://downloads.sourceforge.net/project/nzbget/nzbget-stable/13.0/nzbget-13.0.tar.gz"
  sha1 "dc321ed59f47755bc910cf859f18dab0bf0cc7ff"

  devel do
    url "https://downloads.sourceforge.net/project/nzbget/nzbget-testing/14.0-r1137/nzbget-14.0-testing-r1137.tar.gz"
    sha1 "b416a25c4744ca29be24c08ea240ac59bd19f2f4"
    version "14.0-r1137"
  end

  head "https://nzbget.svn.sourceforge.net/svnroot/nzbget/trunk"

  bottle do
    revision 1
    sha1 "1c3dadeea5e3b2c11c389c47d52b01c178c8dc15" => :mavericks
    sha1 "cc54cc62edb0a8e46984f182e910113746bcd1c1" => :mountain_lion
    sha1 "a16304bb423a561ce4a51a808d3c10717f237d51" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "libsigc++"

  fails_with :clang do
    build 500
    cause <<-EOS.undent
      Clang older than 5.1 requires flexible array members to be POD types.
      More recent versions require only that they be trivially destructible.
      EOS
  end

  resource "libpar2" do
    url "https://launchpad.net/libpar2/trunk/0.4/+download/libpar2-0.4.tar.gz"
    sha1 "c4a5318edac0898dcc8b1d90668cfca2ccfe0375"
  end

  def install
    resource("libpar2").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{libexec}/lp2"
      system "make", "install"
    end

    # Tell configure where libpar2 is, and tell it to use OpenSSL
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libpar2-includes=#{libexec}/lp2/include",
                          "--with-libpar2-libraries=#{libexec}/lp2/lib",
                          "--with-tlslib=OpenSSL"
    system "make"
    ENV.j1
    system "make", "install"
    etc.install "nzbget.conf"
  end

  test do
    # Start nzbget as a server in daemon-mode
    system "#{bin}/nzbget", "-D"
    # Query server for version information
    system "#{bin}/nzbget", "-V"
    # Shutdown server daemon
    system "#{bin}/nzbget", "-Q"
  end
end
