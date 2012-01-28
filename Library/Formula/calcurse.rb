require 'formula'

class Calcurse < Formula
  url 'http://calcurse.org/files/calcurse-2.9.2.tar.gz'
  homepage 'http://calcurse.org/'
  md5 '5cb7d9c9edddc551fc62c9c5733591c5'

  depends_on 'gettext'

  def install
    # need this flag otherwise there is a build error.
    ENV.append 'CFLAGS', "-fnested-functions"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
