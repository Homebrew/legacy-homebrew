require "formula"

class Nzbget < Formula
  homepage "http://nzbget.net/"
  url "https://downloads.sourceforge.net/project/nzbget/nzbget-stable/13.0/nzbget-13.0.tar.gz"
  sha1 "dc321ed59f47755bc910cf859f18dab0bf0cc7ff"

  head "https://nzbget.svn.sourceforge.net/svnroot/nzbget/trunk"

  bottle do
    sha1 "079c3445547cb316a1e6a9bafa58f024ec83c387" => :mavericks
    sha1 "f278128b20c75ec532ccc6ccff4b514217384591" => :mountain_lion
    sha1 "57a8551fed4323e4d9554fcb39d76217b3e3bf33" => :lion
  end

  depends_on "pkg-config" => :build
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
      system "make install"
    end

    # Tell configure where libpar2 is, and tell it to use OpenSSL
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libpar2-includes=#{libexec}/lp2/include",
                          "--with-libpar2-libraries=#{libexec}/lp2/lib",
                          "--with-tlslib=OpenSSL"
    system "make"
    ENV.j1
    system "make install"
    system "make install-conf"
  end
end
