require 'formula'

class MobileShell < Formula
  homepage 'http://mosh.mit.edu/'
  url 'https://github.com/downloads/keithw/mosh/mosh-1.2.tar.gz'
  md5 '2822792d362cc1539278ca3d3afb279a'

  head 'https://github.com/keithw/mosh.git'

  # Needs new autoconf for correct AC_C_RESTRICT macro
  # See: https://github.com/keithw/mosh/issues/241
  depends_on 'autoconf' => :build if ARGV.build_head?
  depends_on 'pkg-config' => :build
  depends_on 'protobuf'

  def install
    system "./autogen.sh" if ARGV.build_head?

    # Upstream prefers O2:
    # https://github.com/keithw/mosh/blob/master/README.md
    ENV.O2
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
