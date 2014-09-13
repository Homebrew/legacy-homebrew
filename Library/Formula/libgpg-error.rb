require 'formula'

class LibgpgError < Formula
  homepage 'http://www.gnupg.org/'
  url 'ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.15.tar.bz2'
  mirror 'http://ftp.heanet.ie/mirrors/ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.15.tar.bz2'
  sha1 'f41791121c66043fa18834597e0155ebcbff8ada'

  bottle do
    cellar :any
    sha1 "827c944f802fc8eb8e237b170afcc931ea724319" => :mavericks
    sha1 "251c8bf21431497bf1018d707dc1510548cde11b" => :mountain_lion
    sha1 "7a4bd350a82007b890845b16bf95aaa18d760c10" => :lion
  end

  # Version 1.15 broke building on OS X.  This has been reported:
  # http://lists.gnupg.org/pipermail/gnupg-devel/2014-September/028748.html
  # and the fix in the below patch is already committed into their
  # repo for next release.
  patch :DATA

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
__END__
--- a/src/gpgrt-int.h
+++ b/src/gpgrt-int.h
@@ -105,9 +105,9 @@ void _gpgrt_clearerr_unlocked (gpgrt_stream_t stream);
 
 int _gpgrt_fflush (gpgrt_stream_t stream);
 int _gpgrt_fseek (gpgrt_stream_t stream, long int offset, int whence);
-int _gpgrt_fseeko (gpgrt_stream_t stream, off_t offset, int whence);
+int _gpgrt_fseeko (gpgrt_stream_t stream, gpgrt_off_t offset, int whence);
 long int _gpgrt_ftell (gpgrt_stream_t stream);
-off_t _gpgrt_ftello (gpgrt_stream_t stream);
+gpgrt_off_t _gpgrt_ftello (gpgrt_stream_t stream);
 void _gpgrt_rewind (gpgrt_stream_t stream);
 
 int _gpgrt_fgetc (gpgrt_stream_t stream);


