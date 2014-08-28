require 'formula'

class Nmap < Formula
  homepage "http://nmap.org/"
  head "https://guest:@svn.nmap.org/nmap/", :using => :svn
  url "http://nmap.org/dist/nmap-6.47.tar.bz2"
  sha1 "0c917453a91a5e85c2a217d27c3853b0f3e0e6ac"

  bottle do
    sha1 "47162f878c916d62a2fcc1031c848ba1e6dd0925" => :mavericks
    sha1 "e8883bc7e925f5fd19bb0ec46770be9417166b03" => :mountain_lion
    sha1 "c7791690ea1f83bfad3b272b5affeda565ef4a4f" => :lion
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
