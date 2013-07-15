require 'formula'

class Lftp < Formula
  homepage 'http://lftp.yar.ru/'
  url 'http://ftp.yar.ru/pub/source/lftp/lftp-4.4.8.tar.bz2'
  mirror 'ftp://ftp.cs.tu-berlin.de/pub/net/ftp/lftp/lftp-4.4.8.tar.bz2'
  sha1 'c825849d90b8132ed43ea5b73fdbb6a63f3e44de'

  # https://github.com/mxcl/homebrew/issues/18749
  env :std

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'gnutls'

  # Hotfix for compiling on Snow Leopard; check if still needed in next release
  # https://github.com/mxcl/homebrew/pull/20435
  # http://comments.gmane.org/gmane.network.lftp.user/2253
  def patches
    DATA
  end

  def install
    # Bus error
    ENV.no_optimization if MacOS.version == :leopard

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/src/buffer_zlib.cc b/src/buffer_zlib.cc
index 2ceaee9..ef79e6f 100644
--- a/src/buffer_zlib.cc
+++ b/src/buffer_zlib.cc
@@ -87,5 +87,5 @@ DataInflator::~DataInflator()
 }
 void DataInflator::ResetTranslation()
 {
-   z_err = inflateReset2(&z, 16+MAX_WBITS);
+   z_err = inflateReset(&z);
 }
