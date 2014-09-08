require 'formula'

class Smartsim < Formula
  homepage 'http://smartsim.org.uk'
  url 'https://github.com/ashleynewson/SmartSim/archive/v1.4.tar.gz'
  sha1 '0bafb811df83366a0b0bf137ce3f76ed9f94e506'
  head 'https://github.com/ashleynewson/smartsim'

  depends_on :x11
  depends_on 'gtk+3'
  depends_on 'librsvg'
  depends_on 'libxml2'
  depends_on 'glib'
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
    system "#{bin}/smartsim", '--version'
  end
end
