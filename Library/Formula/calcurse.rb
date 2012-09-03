require 'formula'

class Calcurse < Formula
  url 'http://calcurse.org/files/calcurse-2.9.2.tar.gz'
  homepage 'http://calcurse.org/'
  sha1 'ab59b3275a9b7eb9184797f9e998e64783b03ceb'

  depends_on 'gettext'

  def install
    # need this flag otherwise there is a build error.
    ENV.append 'CFLAGS', "-fnested-functions"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
