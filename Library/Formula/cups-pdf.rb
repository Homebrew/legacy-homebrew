require 'formula'

class CupsPdf < Formula
  url 'http://www.cups-pdf.de/src/cups-pdf_3.0beta1.tar.gz'
  version '3.0beta1'
  md5 'b5079bc5d86729b0b31d93a77b4a896f'
  homepage 'http://www.cups-pdf.de/'

  # Patch derived from MacPorts.
  # def patches; DATA; end

  def install
    system "#{ENV.cc} #{ENV.cflags} -O9 -lcups -o cups-pdf src/cups-pdf.c"

    (etc+'cups').install "extra/cups-pdf.conf"
    (lib+'cups/backend').install "cups-pdf"
    (share+'cups/model').install "extra/CUPS-PDF_opt.ppd"
  end

  def caveats; <<-EOF.undent
      In order to use cups-pdf with the Mac OS X printing system change the file
      permissions, symlink the necessary files to their System location and
      have cupsd re-read its configuration using:

      chmod 0700 #{lib}/cups/backend/cups-pdf
      sudo chown root #{lib}/cups/backend/cups-pdf
      sudo ln -sf #{etc}/cups/cups-pdf.conf /etc/cups/cups-pdf.conf
      sudo ln -sf #{lib}/cups/backend/cups-pdf /usr/libexec/cups/backend/cups-pdf
      sudo chmod -h 0700 /usr/libexec/cups/backend/cups-pdf
      sudo ln -sf #{share}/cups/model/CUPS-PDF.ppd /usr/share/cups/model/CUPS-PDF.ppd

      sudo mkdir -p /var/spool/cups-pdf/${USER}
      ln -s /var/spool/cups-pdf/${USER} ${HOME}/Documents/cups-pdf
      sudo killall -HUP cupsd

      NOTE: When uninstalling cups-pdf these symlinks need to be removed manually.
    EOF
  end
end

__END__
diff --git a/extra/cups-pdf.conf b/extra/cups-pdf.conf
index cfb4b78..cc8410d 100644
--- a/extra/cups-pdf.conf
+++ b/extra/cups-pdf.conf
@@ -40,7 +40,7 @@
 ##  root_squash! 
 ### Default: /var/spool/cups-pdf/${USER}
 
-#Out /var/spool/cups-pdf/${USER}
+Out ${HOME}/Documents/cups-pdf/
 
 ### Key: AnonDirName
 ##  ABSOLUTE path for anonymously created PDF files
@@ -82,7 +82,7 @@
 ##                      mixed environments    :  3
 ### Default: 3
 
-#Cut 3
+Cut -1
 
 ### Key: Label
 ##  label all jobs with a unique job-id in order to avoid overwriting old
@@ -91,7 +91,7 @@
 ##  0: label untitled documents only, 1: label all documents
 ### Default: 0
 
-#Label 0
+Label 1
 
 ### Key: TitlePref
 ##  where to look first for a title when creating the output filename
@@ -180,7 +180,7 @@
 ##  created directories and log files
 ### Default: lp
 
-#Grp lp
+Grp _lp
 
 
 ###########################################################################
@@ -220,28 +220,28 @@
 ##          or its proper location on your system
 ### Default: /usr/bin/gs
 
-#GhostScript /usr/bin/gs
+GhostScript /usr/bin/pstopdf
 
 ### Key: GSTmp
 ##  location of temporary files during GhostScript operation 
 ##  this must be user-writable like /var/tmp or /tmp ! 
 ### Default: /var/tmp
 
-#GSTmp /var/tmp
+GSTmp /tmp
 
 ### Key: GSCall
 ## command line for calling GhostScript (!!! DO NOT USE NEWLINES !!!)
 ## MacOSX: for using pstopdf set this to %s %s -o %s %s
 ### Default: %s -q -dCompatibilityLevel=%s -dNOPAUSE -dBATCH -dSAFER -sDEVICE=pdfwrite -sOutputFile="%s" -dAutoRotatePages=/PageByPage -dAutoFilterColorImages=false -dColorImageFilter=/FlateEncode -dPDFSETTINGS=/prepress -c .setpdfwrite -f %s
 
-#GSCall %s -q -dCompatibilityLevel=%s -dNOPAUSE -dBATCH -dSAFER -sDEVICE=pdfwrite -sOutputFile="%s" -dAutoRotatePages=/PageByPage -dAutoFilterColorImages=false -dColorImageFilter=/FlateEncode -dPDFSETTINGS=/prepress -c .setpdfwrite -f %s
+GSCall %s %s -o %s %s
 
 ### Key: PDFVer
 ##  PDF version to be created - can be "1.5", "1.4", "1.3" or "1.2" 
 ##  MacOSX: for using pstopdf set this to an empty value
 ### Default: 1.4
 
-#PDFVer 1.4
+PDFVer 
 
 ### Key: PostProcessing
 ##  postprocessing script that will be called after the creation of the PDF
