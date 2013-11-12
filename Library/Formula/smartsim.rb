require 'formula'

class Smartsim < Formula
  homepage 'http://smartsim.org.uk'
  url 'https://github.com/ashleynewson/SmartSim.git', :revision => '7bab4542f5'
  version '1.3.2'

  depends_on :x11
  depends_on 'gtk+3'
  depends_on 'librsvg'
  depends_on 'libxml2'
  depends_on 'glib'
  depends_on 'cairo'
  depends_on 'pkg-config' => :build
  depends_on 'gettext'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "false"
  end
end
