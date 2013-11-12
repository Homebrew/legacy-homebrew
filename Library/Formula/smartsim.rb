require 'formula'

class Smartsim < Formula
  homepage 'http://smartsim.org.uk'
  url 'https://github.com/ashleynewson/SmartSim/archive/v1.2.1.tar.gz'
  sha1 'ee3e5b4b4d7615ebbd9a1e944d0e506e697e7da0'
  head 'https://github.com/ashleynewson/smartsim'

  depends_on :x11
  depends_on 'gtk+'
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
end
