require 'formula'

class Bsdsfv < Formula
  homepage 'http://bsdsfv.sourceforge.net/'
  url 'http://sourceforge.net/projects/bsdsfv/files/bsdsfv/1.18/bsdsfv-1.18.tar.gz'
  sha1 '5e72c5e12bce2d5f77469d8f2425064a0ea6fc1e'

  # bug report:
  # http://sourceforge.net/tracker/?func=detail&aid=2887842&group_id=7211&atid=107211
  # Patch from MacPorts
  def patches
    DATA
  end

  def install
    bin.mkpath

    inreplace 'Makefile' do |s|
      s.change_make_var! "INSTALL_PREFIX", prefix
      s.change_make_var! "INDENT", "indent"
      s.gsub! '	${INSTALL_PROGRAM} bsdsfv ${INSTALL_PREFIX}/bin', "	${INSTALL_PROGRAM} bsdsfv #{bin}/"
    end

    system "make all"
    system "make install"
  end
end

__END__
--- a/bsdsfv.c	2012-09-25 07:31:03.000000000 -0500
+++ b/bsdsfv.c	2012-09-25 07:31:08.000000000 -0500
@@ -44,5 +44,5 @@
 typedef struct sfvtable {
	char filename[FNAMELEN];
-	int crc;
+	unsigned int crc;
	int found;
 } SFVTABLE;
