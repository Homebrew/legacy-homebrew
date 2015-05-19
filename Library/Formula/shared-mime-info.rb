class SharedMimeInfo < Formula
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "http://freedesktop.org/~hadess/shared-mime-info-1.4.tar.xz"
  sha256 "bbc0bd023f497dfd75e1ca73441cbbb5a63617d9e14f2790b868361cc055b5b1"

  head do
    url "http://anongit.freedesktop.org/git/xdg/shared-mime-info.git"
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
    system bin/"update-mime-database", share/"mime"
  end
end
