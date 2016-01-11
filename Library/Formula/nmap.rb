class Nmap < Formula
  desc "Port scanning utility for large networks"
  homepage "https://nmap.org/"
  url "https://nmap.org/dist/nmap-7.01.tar.bz2"
  sha256 "cf1fcd2643ba2ef52f47acb3c18e52fa12a4ae4b722804da0e54560704627705"
  head "https://guest:@svn.nmap.org/nmap/", :using => :svn

  bottle do
    sha256 "644e1272f7a88282786489227046ae6adfb1619ba0aab7728f571dd075935db9" => :el_capitan
    sha256 "19c07ff23d45d33e8e85ef7f8c919e584c2024a5266939a47ac53d171cf21dc6" => :yosemite
    sha256 "a3d47249831e4959b4fa443c463fd52a59997cc1eb20d21361f79691ca39f1d4" => :mavericks
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
