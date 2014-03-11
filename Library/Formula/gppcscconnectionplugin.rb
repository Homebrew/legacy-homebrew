require "formula"

class Gppcscconnectionplugin < Formula
  homepage "http://sourceforge.net/p/globalplatform/wiki/Home/"
  url "https://downloads.sourceforge.net/project/globalplatform/GlobalPlatform%20Library/GlobalPlatform%20Library%206.0.0/gppcscconnectionplugin-1.1.0.tar.gz"
  sha1 "38eb3d739f1b75ba954f09a928a6e9db0178ea53"

  depends_on 'globalplatform'

  # ./configure doesn't recognize GlobalPlatform without this
  depends_on 'pkg-config' => :build

  def install
    ENV.append 'PCSCLITE_CFLAGS', "-I#{MacOS.sdk_path}/System/Library/Frameworks/PCSC.framework/Versions/A/Headers/"
    ENV.append 'GLOBALPLATFORM_CFLAGS', "-I#{Formula["globalplatform"].opt_prefix}/include/globalplatform"
    ENV.append 'GLOBALPLATFORM_LIBS', "#{Formula["globalplatform"].opt_prefix}/lib/libglobalplatform.dylib"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
