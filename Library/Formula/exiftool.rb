require 'formula'

class Exiftool <Formula
  url 'http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-8.18.tar.gz'
  homepage 'http://www.sno.phy.queensu.ca/~phil/exiftool/index.html'
  md5 '549607a165499db04bc69019119099f8'

  def install
    system "perl", "Makefile.PL"
    system "make", "test"
    
    # Install privately to the Cellar
    libexec.install ["exiftool", "lib"]
    
    # Link the executable script into "bin"
    bin.mkpath
    ln_s libexec+"exiftool", bin
  end
end
