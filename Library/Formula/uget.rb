class Uget < Formula

  homepage "http://ugetdm.com/"
  url "https://downloads.sourceforge.net/project/urlget/uget%20%28stable%29/1.10.4/uget-1.10.4.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Furlget%2F&ts=1414661146"
  sha1 "eced8dd7d8b9d33b67ada5798e31f4a5eff06da2"

  depends_on :x11
  depends_on "gtk+3"
  depends_on 'intltool' => :build
  depends_on 'pkg-config' => :build
  depends_on "gstreamer"

  def install

    system "./configure", "--disable-notify",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
