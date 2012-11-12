require 'formula'

class Crossroads < Formula
  homepage 'http://www.crossroads.io/'
  url 'http://download.crossroads.io/libxs-1.2.0.tar.gz'
  sha1 'd9633e6df56e3ed0c4f0e86d80ee0ae10c8a966a'

  head 'https://github.com/crossroads-io/libxs.git'

  option 'with-pgm', 'Build with PGM extension'

  depends_on 'pkg-config' => :build
  depends_on :automake
  depends_on :libtool
  depends_on 'libpgm' if build.include? 'with-pgm'

  fails_with :llvm do
    build 2326
    cause "Compiling with LLVM gives a segfault while linking."
  end

  def install
    system "./autogen.sh" if build.head?

    # Help it find openpgm-5.2 because it searches for openpgm-5.1.pc
    # https://github.com/mxcl/homebrew/issues/15217
    if build.include? 'with-pgm'
      libpgm = Formula.factory('libpgm')
      ENV['OpenPGM_CFLAGS'] = "-I#{libpgm.include}/pgm-5.2 -I#{libpgm.lib}/pgm-5.2/include"
      ENV['OpenPGM_LIBS'] = "-L#{libpgm.lib} -lpgm"
    end

    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--with-system-pgm" if build.include? 'with-pgm'
    system "./configure", *args

    system "make"
    system "make install"
  end
end
