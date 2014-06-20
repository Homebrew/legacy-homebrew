require 'formula'

class Libgsm < Formula
  homepage 'http://www.quut.com/gsm/'
  url 'http://www.quut.com/gsm/gsm-1.0.13.tar.gz'
  sha1 '668b0a180039a50d379b3d5a22e78da4b1d90afc'

  option :universal

  # Builds a dynamic library for gsm, this package is no longer developed
  # upstream. Patch taken from Debian and modified to build a dylib.
  patch do
    url "https://gist.githubusercontent.com/dholm/5840964/raw/1e2bea34876b3f7583888b2284b0e51d6f0e21f4/gistfile1.txt"
    sha1 "41fff9bb2dc4958aeb503180ab30ae2e45354e54"
  end

  def install
    ENV.universal_binary if build.universal?
    ENV.append_to_cflags '-c -O2 -DNeedFunctionPrototypes=1'

    # Only the targets for which a directory exists will be installed
    bin.mkpath
    lib.mkpath
    include.mkpath
    man1.mkpath
    man3.mkpath

    # Dynamic library must be built first
    system "make", "lib/libgsm.1.0.13.dylib",
           "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}",
           "LDFLAGS=#{ENV.ldflags}"
    system "make", "all",
           "CC=#{ENV.cc}", "CCFLAGS=#{ENV.cflags}",
           "LDFLAGS=#{ENV.ldflags}"
    system "make", "install",
           "INSTALL_ROOT=#{prefix}",
           "GSM_INSTALL_INC=#{include}"
    lib.install Dir['lib/*dylib']
  end
end
