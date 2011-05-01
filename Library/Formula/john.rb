require 'formula'

class John < Formula
  url 'http://www.openwall.com/john/g/john-1.7.7-jumbo-1.tar.gz'
  homepage 'http://www.openwall.com/john/'
  md5 'b5fde123f4c5f230c5ccda3b765b2de2'
  version '1.7.7-jumbo-1'

  def patches
    { :p0 => DATA }
  end

  def install
    ENV.deparallelize

    arch = Hardware.is_64_bit? ? '64' : 'sse2'

    Dir.chdir 'src' do
      system "make clean macosx-x86-#{arch}"
    end

    (share+'john').mkpath

    cp Dir["run/*.chr"], share+'john'
    cp 'run/john.conf', share+'john'
    cp 'run/password.lst', share+'john'
    cp 'run/stats', share+'john'

    bin.install [
      'run/calc_stat',
      'run/genmkvpwd',
      'run/john',
      'run/mailer',
      'run/mkvcalcproba',
      'run/tgtsnarf'
    ]

    File.symlink bin+'john', bin+'unafs'
    File.symlink bin+'john', bin+'undrop'
    File.symlink bin+'john', bin+'unique'
    File.symlink bin+'john', bin+'unshadow'

  end
end

__END__
--- src/params.h.orig	2011-05-01 15:35:06.000000000 -0300
+++ src/params.h	2011-05-01 15:35:43.000000000 -0300
@@ -53,15 +53,15 @@
  * notes above.
  */
 #ifndef JOHN_SYSTEMWIDE
-#define JOHN_SYSTEMWIDE			0
+#define JOHN_SYSTEMWIDE			1
 #endif

 #if JOHN_SYSTEMWIDE
 #ifndef JOHN_SYSTEMWIDE_EXEC /* please refer to the notes above */
-#define JOHN_SYSTEMWIDE_EXEC		"/usr/libexec/john"
+#define JOHN_SYSTEMWIDE_EXEC		"/usr/local/libexec/john"
 #endif
 #ifndef JOHN_SYSTEMWIDE_HOME
-#define JOHN_SYSTEMWIDE_HOME		"/usr/share/john"
+#define JOHN_SYSTEMWIDE_HOME		"/usr/local/share/john"
 #endif
 #define JOHN_PRIVATE_HOME		"~/.john"
 #endif

 --- run/john.conf.orig	2011-05-01 15:42:00.000000000 -0300
 +++ run/john.conf	2011-05-01 15:42:54.000000000 -0300
 @@ -7,9 +7,9 @@

  [Options]
  # Wordlist file name, to be used in batch mode
 -Wordlist = $JOHN/password.lst
 +Wordlist = /usr/local/share/john/password.lst
  # Default Markov mode settings
 -Statsfile = $JOHN/stats
 +Statsfile = /usr/local/share/john/stats
  MkvLvl = 200
  MkvMaxLen = 12
  # Use idle cycles only
 @@ -282,31 +282,31 @@

  # Incremental modes
  [Incremental:All]
 -File = $JOHN/all.chr
 +File = /usr/local/share/john/all.chr
  MinLen = 0
  MaxLen = 8
  CharCount = 95

  [Incremental:Alpha]
 -File = $JOHN/alpha.chr
 +File = /usr/local/share/john/alpha.chr
  MinLen = 1
  MaxLen = 8
  CharCount = 26

  [Incremental:Digits]
 -File = $JOHN/digits.chr
 +File = /usr/local/share/john/digits.chr
  MinLen = 1
  MaxLen = 8
  CharCount = 10

  [Incremental:Alnum]
 -File = $JOHN/alnum.chr
 +File = /usr/local/share/john/alnum.chr
  MinLen = 1
  MaxLen = 8
  CharCount = 36

  [Incremental:LanMan]
 -File = $JOHN/lanman.chr
 +File = /usr/local/share/john/lanman.chr
  MinLen = 0
  MaxLen = 7
  CharCount = 69
