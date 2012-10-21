require 'formula'

class MobileShell < Formula
  homepage 'http://mosh.mit.edu/'
  url 'https://github.com/downloads/keithw/mosh/mosh-1.2.3.tar.gz'
  sha1 '3bbcc560a5968806681465d83758d5c3abee9607'

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
