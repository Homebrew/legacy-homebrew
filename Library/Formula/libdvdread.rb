class Libdvdread < Formula
  desc "C library for reading DVD-video images"
  homepage "https://dvdnav.mplayerhq.hu/"
  url "https://download.videolan.org/pub/videolan/libdvdread/5.0.3/libdvdread-5.0.3.tar.bz2"
  sha256 "321cdf2dbdc83c96572bc583cd27d8c660ddb540ff16672ecb28607d018ed82b"

  head do
    url "git://git.videolan.org/libdvdread.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha256 "678d4bf550fa4e1201086e3c85eb0bb8de6879e8aa69d8d8211d71b924842863" => :el_capitan
    sha256 "6bc87a7812abdcf38c9a3b82265f9c8ec3cc96d466e4e2a46025ea68deb17744" => :yosemite
    sha256 "43a49a9aa58338209523b6ea1075eb86bfdd33a0522b80777baf931ddd666382" => :mavericks
    sha256 "cb517d55f5a83de483350f01a12507d86a3bcd1c305b612add084beae20dd4c6" => :mountain_lion
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
