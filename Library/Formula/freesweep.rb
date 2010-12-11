require 'formula'

class Freesweep <Formula
  url 'http://ftp.debian.org/pool/main/f/freesweep/freesweep_0.90.orig.tar.gz'
  homepage 'http://ftp.debian.org/pool/main/f/freesweep/'
  md5 'fc737e390602e3318297d9adc304da3b'

  def patches
      DATA
  end

  def install
    # Configure can not guess the Darwin host type. We will fake the use of
    # linux. This does not affect it's ability to be compiled. Only that
    # configure will run. configure also blindly assumes ncurses is in
    # /usr/local. We have to tell it manually that it is in /usr.
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--with-ncurses=/usr", "--with-prefsdir=#{share}",
                          "--with-scoresdir=#{share}", "--build=i686-pc-linux-gnu",
                          "--mandir=#{man}", "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
--- a/Makefile.in	2002-12-28 00:57:37.000000000 -0500
+++ b/Makefile.in	2010-12-11 18:13:00.000000000 -0500
@@ -60,10 +60,10 @@
 
 install: $(TARGET) $(TARGET).6
 	touch sweeptimes
-	./install-sh -c -m 2555 -o root -g games -s $(TARGET) $(bindir)/$(TARGET)
-	./install-sh -c -m 0664 -o root -g games sweeptimes @SCORESDIR@/sweeptimes
-	./install-sh -c -m 0644 -o root -g games sweeprc @PREFSDIR@/sweeprc
-	./install-sh -c -m 0444 -o root -g games $(TARGET).6 @mandir@/man6/$(TARGET).6
+	./install-sh -c -m 2555 -s $(TARGET) $(bindir)/$(TARGET)
+	./install-sh -c -m 0664 sweeptimes @SCORESDIR@/sweeptimes
+	./install-sh -c -m 0644 sweeprc @PREFSDIR@/sweeprc
+	./install-sh -c -m 0444 $(TARGET).6 @mandir@/man6/$(TARGET).6
 
 distclean:
 	@make sterile
