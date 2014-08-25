require 'formula'

class Nmap < Formula
  homepage "http://nmap.org/"
  head "https://guest:@svn.nmap.org/nmap/", :using => :svn
  url "http://nmap.org/dist/nmap-6.46.tar.bz2"
  sha1 "e19dd4d35d76b24b084665b90c423f53bc7fdcfe"
  revision 1

  bottle do
    sha1 "4f538d605c9c115977e8e4464f1c194438de8dfc" => :mavericks
    sha1 "d5d4dbe156c561cbd5da850ac1f5f94d54309060" => :mountain_lion
    sha1 "51ca13897ee50d340b1d8e36b60cc12ecb47a0b3" => :lion
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
