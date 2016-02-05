class Libopendkim < Formula
  desc "Implementation of Domain Keys Identified Mail authentication"
  homepage "http://opendkim.org"
  url "https://downloads.sourceforge.net/project/opendkim/opendkim-2.10.3.tar.gz"
  sha256 "43a0ba57bf942095fe159d0748d8933c6b1dd1117caf0273fa9a0003215e681b"

  bottle do
    revision 1
    sha256 "6b5052b456871186bc251a2e9551c87ca53c501bf162f104c4841fa07b4f2458" => :el_capitan
    sha256 "cf601de122898a144b1c42c72980f1a19688c718638df2ab49735c65a9beb1ce" => :yosemite
    sha256 "d1399f0f0bf8f13aee75557d516b7e09cc31155c3b72da6159e13f25ff94cbd8" => :mavericks
  end

  depends_on "unbound"
  depends_on "openssl"

  def install
    # --disable-filter: not needed for the library build
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-filter",
                          "--with-unbound=#{Formula["unbound"].opt_prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/opendkim-genkey", "--directory=#{testpath}"
    assert File.exist?("default.private")
    assert File.exist?("default.txt")
  end
end
