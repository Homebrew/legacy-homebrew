require "formula"

class Nzbget < Formula
  homepage "http://nzbget.net/"
  url "https://downloads.sourceforge.net/project/nzbget/nzbget-stable/14.0/nzbget-14.0.tar.gz"
  sha1 "bb45cbf7c53d94544b03d15adec327df6dfaeb19"

  head "https://nzbget.svn.sourceforge.net/svnroot/nzbget/trunk"

  bottle do
    sha1 "39db25fa2d79c924cf0aa706c7180c0650734c32" => :yosemite
    sha1 "43478c1ccb216da5d58e8dfee64d7c3e13086d8e" => :mavericks
    sha1 "21db9c9bbcf94ce4ef0862f1c2f1b4a5d59d6f68" => :mountain_lion
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
