class SharedMimeInfo < Formula
  desc "Database of common MIME types"
  homepage "https://wiki.freedesktop.org/www/Software/shared-mime-info"
  url "http://freedesktop.org/~hadess/shared-mime-info-1.5.tar.xz"
  sha256 "d6412840eb265bf36e61fd7b6fc6bea21b0f58cb22bed16f2ccccdd54bea4180"

  bottle do
    cellar :any
    sha256 "d9319f2574b82d7d17b413233307bfbd32691604194244d8ff529aae79db52c6" => :yosemite
    sha256 "3931c3aa4e637cfb64617f8b0a9b7ceda2520a96c08fdb45235f138268d81064" => :mavericks
    sha256 "0d66e477d10e982d33ad14c0824419738c5e465ae767f0fcda4e8f11dd82097b" => :mountain_lion
  end

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
