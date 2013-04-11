require 'formula'

class Calcurse < Formula
  homepage 'http://calcurse.org/'
  url 'http://calcurse.org/files/calcurse-2.9.2.tar.gz'
  sha1 'ab59b3275a9b7eb9184797f9e998e64783b03ceb'

  depends_on 'gettext'

  fails_with :clang do
    build 421
    cause "Issue with macro expansion in htable.h"
  end

  def install
    # need this flag otherwise there is a build error.
    ENV.append 'CFLAGS', "-fnested-functions"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
