class Efl < Formula
  homepage "https://www.enlightenment.org"
  url "http://download.enlightenment.org/rel/libs/efl/efl-1.14.0-beta1.tar.gz"
  sha1 "ff4cb8b238bbfd0fef392009b9889f72288ef5da"

  conflicts_with "eina"
  conflicts_with "evas"
  conflicts_with "eet"
  conflicts_with "embryo"

  option "with-docs", "Install development libraries/headers and HTML docs"

  depends_on 'pkg-config' => :build
  depends_on :x11
  depends_on 'jpeg'
  depends_on 'libpng'
  depends_on 'webp' => :optional
  depends_on 'luajit'
  depends_on 'fribidi'
  depends_on 'giflib'
  depends_on 'gstreamer'
  depends_on 'gst-plugins-good'
  depends_on 'd-bus'
  depends_on 'pulseaudio'
  depends_on 'bullet'
  depends_on "doxygen" => :build if build.with? "docs"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--enable-cocoa",
                          "--prefix=#{prefix}"
    system "make", "install"
    system "make", "install-doc" if build.with? "docs"
  end

  test do
    system "#{bin}/edje_cc", "-V"
  end
end
