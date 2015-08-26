class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  head "https://guest:@svn.nmap.org/nmap/", :using => :svn
  url "https://nmap.org/dist/nmap-6.47.tar.bz2"
  sha256 "8fa11e9e203ce2d81a207db5ca4f110a525f6c01c1dd0018325a7112a51aa591"

  bottle do
    revision 2
    sha256 "9b6d72f580b7da225aedadad7682242356c80df9aa3f35153d040148dacf9d07" => :yosemite
    sha256 "c452ee2ac7166b7330a5b4ec523d2a0ab166a05702816d1e0198afa36927a80d" => :mavericks
    sha256 "73c5cc0e510d834016a13bc37013454805435db55575af53eb49d23d27a8756a" => :mountain_lion
  end

  depends_on "openssl"

  conflicts_with "ndiff", :because => "both install `ndiff` binaries"

  fails_with :llvm do
    build 2334
  end

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --with-libpcre=included
      --with-liblua=included
      --with-openssl=#{Formula["openssl"].opt_prefix}
      --without-nmap-update
      --without-zenmap
      --disable-universal
    ]

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make", "install"
  end

  test do
    system "#{bin}/nmap", "-p80,443", "google.com"
  end
end
