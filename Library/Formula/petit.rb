require 'formula'

class Petit < Formula
  homepage 'http://crunchtools.com/software/petit/'
  url 'http://crunchtools.com/wp-content/files/petit/petit-current.tgz'
  version '1.1.1'
  sha1 '8acdb35e235b7189af629985b1177f0cf91adafc'

  def patches
    # configurable install prefix
    { :p0 => DATA }
  end

  def install
    ENV['PREFIX']="#{prefix}"
    ENV['MAN1']="#{man1}"

    # several python scripts directly reference the libs directory
    # so we give them a new reference to use
    inreplace "src/bin/petit", '/usr/share/petit', "#{share}/petit"
    [ "src/lib/crunchtools/Filter.py",
      "src/lib/crunchtools/LogHash.py",
      "src/man/petit.1"].each do |f|

      inreplace f, '/var/lib/petit/', "#{lib}/petit/"
    end

    man1.mkpath
    system "build/scripts/tar-install.sh"
  end

  def test
    # make sure petit can read and hash
    system "petit --hash /var/log/system.log"
  end
end


__END__

--- build/scripts/tar-install.sh  2011-02-18 06:42:04.000000000 +1100
+++ petit.brew/build/scripts/tar-install.sh 2012-12-21 00:04:39.000000000 +1100
@@ -7,32 +7,32 @@
 # systems such as OSX, Solaris, etc. It has not been test on every platform,
 # but it is fairly simple and should work on most.
 # 
-# You must be root to run this script
+# You no longer must be root to run this script
 
 # Main scripts & libraries
-mkdir -p /usr/bin
-mkdir -p /usr/share/petit
-cp -vf ./src/bin/petit /usr/bin/petit
-cp -vf ./src/lib/crunchtools/* /usr/share/petit/crunchtools/
-cp -vf ./src/man/petit.1.gz /usr/share/man/man1/petit.1.gz
+mkdir -p ${PREFIX}/bin 
+mkdir -p ${PREFIX}/share/petit
+cp -vf ./src/bin/petit ${PREFIX}/bin/petit
+cp -vfr ./src/lib/crunchtools ${PREFIX}/share/petit/crunchtools
+cp -vf ./src/man/petit.1 ${MAN1}/petit.1
 
 # Filters
-mkdir -p /var/lib/petit/filters
-cp -vf ./src/lib/filters/*.stopwords /var/lib/petit/filters/
+mkdir -p ${PREFIX}/lib/petit/filters
+cp -vf ./src/lib/filters/*.stopwords ${PREFIX}/lib/petit/filters/
 
 # Fingerprints
-mkdir -p /var/lib/petit/fingerprints
-cp -vf src/lib/fingerprints/* /var/lib/petit/fingerprints/
+mkdir -p ${PREFIX}/lib/petit/fingerprints
+cp -vf src/lib/fingerprints/* ${PREFIX}/lib/petit/fingerprints/
 
 # Fingerprint Library
-mkdir -p /var/lib/petit/fingerprint_library
-cp -vf ./src/lib/fingerprint_library/* /var/lib/petit/fingerprint_library/
+mkdir -p ${PREFIX}/lib/petit/fingerprint_library
+cp -vf ./src/lib/fingerprint_library/* ${PREFIX}/lib/petit/fingerprint_library/
 
 # Licensing & Docs
-mkdir -p /usr/share/doc/petit
-cp -vf README /usr/share/doc/petit/README
-cp -vf AUTHORS /usr/share/doc/petit/AUTHORS
-cp -vf COPYING /usr/share/doc/petit/COPYING
+mkdir -p ${PREFIX}/share/doc/petit
+cp -vf README ${PREFIX}/share/doc/petit/README
+cp -vf AUTHORS ${PREFIX}/share/doc/petit/AUTHORS
+cp -vf COPYING ${PREFIX}/share/doc/petit/COPYING
 
 # Completed
 echo "Files and libraries installed"
