require 'formula'

class MobileShell < Formula
  homepage 'http://mosh.mit.edu/'
  url 'https://github.com/downloads/keithw/mosh/mosh-1.2.3.tar.gz'
  sha1 '2f95ae6f4610f1193250043e6c18496085ebfa0a'

  head 'https://github.com/keithw/mosh.git'

  # Needs new autoconf for correct AC_C_RESTRICT macro
  # See: https://github.com/keithw/mosh/issues/241
  depends_on 'autoconf' => :build if build.head?
  depends_on 'automake' => :build if build.head?
  depends_on 'pkg-config' => :build
  depends_on 'protobuf'

  def install
    system "./autogen.sh" if build.head?

    # Upstream prefers O2:
    # https://github.com/keithw/mosh/blob/master/README.md
    ENV.O2
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
