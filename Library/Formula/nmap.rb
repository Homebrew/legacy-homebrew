require 'formula'

class Nmap < Formula
  homepage "http://nmap.org/"
  head "https://guest:@svn.nmap.org/nmap/", :using => :svn
  url "http://nmap.org/dist/nmap-6.47.tar.bz2"
  sha1 "0c917453a91a5e85c2a217d27c3853b0f3e0e6ac"

  bottle do
    sha1 "08b86ca7e3add3bae810d11d18f45e7eab637b23" => :mavericks
    sha1 "ce539008404668316faa2f9807313392599afbf6" => :mountain_lion
    sha1 "363d82b97e2e6efb47811aebb77c01c442d113df" => :lion
  end

  depends_on "openssl"

  conflicts_with 'ndiff', :because => 'both install `ndiff` binaries'

  fails_with :llvm do
    build 2334
  end

  def install
    ENV.deparallelize

    args = %W[
      --prefix=#{prefix}
      --with-libpcre=included
      --with-liblua=included
      --with-openssl=#{Formula["openssl"].prefix}
      --without-nmap-update
      --without-zenmap
      --disable-universal
    ]

    system "./configure", *args
    system "make" # separate steps required otherwise the build fails
    system "make install"
  end

  test do
    system "#{bin}/nmap", '-p80,443', 'google.com'
  end
end
