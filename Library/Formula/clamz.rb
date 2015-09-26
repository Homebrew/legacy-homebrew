class Clamz < Formula
  desc "Download MP3 files from Amazon's music store"
  homepage "https://code.google.com/p/clamz/"
  url "https://clamz.googlecode.com/files/clamz-0.5.tar.gz"
  sha256 "5a63f23f15dfa6c2af00ff9531ae9bfcca0facfe5b1aa82790964f050a09832b"
  revision 1

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/clamz"
  end
end
