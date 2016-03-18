class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.10.tar.bz2"
  sha256 "58cf8896d09057d1c3533f430c06b22791d0227ebbb93dede2ccb73693ed4b4b"
  head "https://guest:@svn.nmap.org/nmap/", :using => :svn

  bottle do
    sha256 "05d373af1509126f5be52bf24e5e15f0910b7dfa0e49f7b923960c83f9a37d24" => :el_capitan
    sha256 "b1f3a5f7edb1a3bd328eebbf8dd2175ea22db05c552115fde70651240d770554" => :yosemite
    sha256 "94585a4e818543710769e2fa17f5f2abba2082d278cf45e47e40941ce64c20ec" => :mavericks
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
