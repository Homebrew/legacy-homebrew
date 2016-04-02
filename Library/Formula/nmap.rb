class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.12.tar.bz2"
  sha256 "63df082a87c95a189865d37304357405160fc6333addcf5b84204c95e0539b04"
  head "https://guest:@svn.nmap.org/nmap/", :using => :svn

  bottle do
    sha256 "1225505f7b77cafa55d300adffc2e1c5945d090a20cb18c417bead62a2eb0409" => :el_capitan
    sha256 "a57b65e0c14e232b332b332bbaa5e3ab9b07b4b07e9e3f36dc1cc6afbb4d42f9" => :yosemite
    sha256 "be7ba56789fa1aa900396955d2a99c1929907ca8df1a9ccd37081d5178c440de" => :mavericks
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
