require 'formula'

class Nmap < Formula
  homepage "http://nmap.org/"
  head "https://guest:@svn.nmap.org/nmap/", :using => :svn
  url "http://nmap.org/dist/nmap-6.45.tar.bz2"
  sha1 "3a634d319c57f6d93e5ccb69b45c133690d437e1"

  bottle do
    sha1 "15741e8fb3f58776fd1245782585d832fe08c1bf" => :mavericks
    sha1 "76ab79880f2ad3db2f965645aa8665d69442f137" => :mountain_lion
    sha1 "276181d845c199735c559031acb893b5b27de561" => :lion
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
