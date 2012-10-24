require 'formula'

class Geany < Formula
  homepage 'http://geany.org/'
  url 'https://github.com/geany/geany/tarball/1.22.0'
  head 'git://github.com/geany/geany.git', :branch => 'master'
  sha256 '0b08d020f9e09a8756595ca9159a43785010519bf5036c7b5acbcf2d8c7e2b9e'

  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'gettext'
  depends_on 'intltool'
  depends_on 'gtk+'

  def install
    # Needed to compile against current version of glib.
    # Check that this is still needed when updating the formula.
    ENV.append 'LDFLAGS', '-lgmodule-2.0'

    system "./autogen.sh", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
