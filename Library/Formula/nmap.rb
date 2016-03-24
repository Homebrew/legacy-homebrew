class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.11.tar.bz2"
  sha256 "13fa971555dec00e495a5b72c1f9efa1363b8e6c7388a2f05117cb0778c0954a"
  head "https://guest:@svn.nmap.org/nmap/", :using => :svn

  bottle do
    sha256 "1f01d36441f75d412b0e9286239316550690110bf5107e15e0d574d1df4e164a" => :el_capitan
    sha256 "c9157eea44176abb56d038423a141f21ec0b78be01c216ae0e3a226e20d0c15c" => :yosemite
    sha256 "561a91b2614b01db6b9fb29f6592f710e37dfba3591df3dcde74852f9012d2ce" => :mavericks
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
