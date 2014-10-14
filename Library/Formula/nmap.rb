require 'formula'

class Nmap < Formula
  homepage "http://nmap.org/"
  head "https://guest:@svn.nmap.org/nmap/", :using => :svn
  url "http://nmap.org/dist/nmap-6.47.tar.bz2"
  sha1 "0c917453a91a5e85c2a217d27c3853b0f3e0e6ac"

  bottle do
    revision 1
    sha1 "f866508268e57a381a1c2456456c5580f83e5bc4" => :mavericks
    sha1 "c80f12d6d1a52bca5ff152404a84a5c4436ba7b3" => :mountain_lion
    sha1 "28da4ac4b94c636b1acd02ca1b17cbb799f86f3f" => :lion
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
