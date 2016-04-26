class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "https://freedesktop.org/~hadess/shared-mime-info-1.6.tar.xz"
  sha256 "b2f8f85b6467933824180d0252bbcaee523f550a8fbc95cc4391bd43c03bc34c"

  bottle do
    cellar :any
    sha256 "c15a6880f3d792cefbaa2f3feeb27964000e29fbfc1b9a8a13c4778218f8ae35" => :el_capitan
    sha256 "1e31d34a91f0575681161ad1de7a3f66cb6a4c88c9da5eb3ae9b67e92ae06265" => :yosemite
    sha256 "030cac04169f6af88c0b86d04853573900c5a7f47b279ffc599c0856e35c795e" => :mavericks
  end

  head do
    url "https://anongit.freedesktop.org/git/xdg/shared-mime-info.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "intltool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"

  def install
    # Disable the post-install update-mimedb due to crash
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-update-mimedb
    ]
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    cp_r share/"mime", testpath
    system bin/"update-mime-database", testpath/"mime"
  end
end
