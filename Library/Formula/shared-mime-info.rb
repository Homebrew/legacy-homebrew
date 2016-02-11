class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "https://freedesktop.org/~hadess/shared-mime-info-1.5.tar.xz"
  sha256 "d6412840eb265bf36e61fd7b6fc6bea21b0f58cb22bed16f2ccccdd54bea4180"

  bottle do
    cellar :any
    sha256 "468c2855ef005f17e153c002241cc6aad2f976e0d1f1be8eb7cbe469f834da3b" => :el_capitan
    sha256 "c2de862bae867d39c6def1f6f1bc078ff73d0ac03b78d321ad3b715de8e20ae0" => :yosemite
    sha256 "48f55fca160358a009282ee9e5c86e74f55bd74f8e31072f0ca5339804f6035c" => :mavericks
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
