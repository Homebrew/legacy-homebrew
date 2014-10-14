require "formula"

class Libdvdread < Formula
  homepage "https://dvdnav.mplayerhq.hu/"
  url "http://download.videolan.org/pub/videolan/libdvdread/5.0.0/libdvdread-5.0.0.tar.bz2"
  sha256 "66fb1a3a42aa0c56b02547f69c7eb0438c5beeaf21aee2ae2c6aa23ea8305f14"

  head do
    url "git://git.videolan.org/libdvdread.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha1 "5b9d6338e4ea67d2e5a498e85daf6bf1f54c14d0" => :mavericks
    sha1 "8e739df5e4ba89e20799d9bfe4a6b174a49eecf3" => :mountain_lion
    sha1 "67ddd413260c5d9d216f5d16ebd21cb5fe9ea4f0" => :lion
  end

  depends_on "libdvdcss"

  def install
    ENV.append "CFLAGS", "-DHAVE_DVDCSS_DVDCSS_H"
    ENV.append "LDFLAGS", "-ldvdcss"

    system "autoreconf", "-if" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
