require 'formula'

class Ncdc < Formula
  homepage 'http://dev.yorhel.nl/ncdc'
  url 'http://dev.yorhel.nl/download/ncdc-1.19.tar.gz'
  sha1 '7f478b7daf09202586b40899cc6beabeb0d23178'
  revision 1

  option 'with-geoip', "Build with geoip support"

  depends_on 'glib'
  depends_on 'sqlite'
  depends_on 'gnutls' => 'with-p11-kit'
  depends_on 'pkg-config' => :build
  depends_on 'geoip' => :optional

  def install
    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
    ]
    args << '--with-geoip' if build.with? 'geoip'

    system "./configure", *args
    system "make install"
  end

  test do
    system "#{bin}/ncdc", "-v"
  end
end
