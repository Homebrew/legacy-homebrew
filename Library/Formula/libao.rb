class Libao < Formula
  desc "Cross-platform Audio Library"
  homepage "https://www.xiph.org/ao/"
  url "http://downloads.xiph.org/releases/ao/libao-1.2.0.tar.gz"
  sha256 "03ad231ad1f9d64b52474392d63c31197b0bc7bd416e58b1c10a329a5ed89caf"

  bottle do
    revision 1
    sha256 "159aa7704f0a3cd36bfdf659ca8ec9c399077274bff1b68aa0497fdda8b6da44" => :el_capitan
    sha1 "9654b94ab07fed570d4b1ea71473a9f9f8020e43" => :yosemite
    sha1 "7a897f67a80378e5b4c838c7a45d03acc1f9b391" => :mavericks
    sha1 "f6fac2951b26b0df3a91da55ad5763e23183eace" => :mountain_lion
  end

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"
  end
end
