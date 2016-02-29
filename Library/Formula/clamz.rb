class Clamz < Formula
  desc "Download MP3 files from Amazon's music store"
  homepage "https://code.google.com/archive/p/clamz/"
  url "https://clamz.googlecode.com/files/clamz-0.5.tar.gz"
  sha256 "5a63f23f15dfa6c2af00ff9531ae9bfcca0facfe5b1aa82790964f050a09832b"
  revision 1

  bottle do
    cellar :any
    sha256 "b960106e00e01e4dd8ff259feab6e0a1e399d373aa79d2b5d622f2ccf6f1e41b" => :el_capitan
    sha256 "e0ba09e61f28b4d224f20b0922277b849bff48ce8c7738e8d22fe1a514d56fe2" => :yosemite
    sha256 "70f9f355c7f53a6201b5e175dbc6db9b1f8b275327250a1e70e06d5c139c2a53" => :mavericks
  end

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
