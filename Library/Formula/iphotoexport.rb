require 'formula'

class Iphotoexport < Formula
  url 'http://iphotoexport.googlecode.com/files/iphotoexport-1.6.4.zip'
  homepage 'http://code.google.com/p/iphotoexport/'
  sha1 '50fa0916cf9689efdfd33cd4680424234b4e9023'

  depends_on 'exiftool'

  def install
    unzip_dir = @name+'-'+@version
    # Change hardcoded exiftool path
    inreplace "#{unzip_dir}/tilutil/exiftool.py", "/usr/bin/exiftool", "exiftool"

    prefix.install Dir[unzip_dir+'/*']
    bin.mkpath
    ln_s prefix+'iphotoexport.py', bin+'iphotoexport'
  end
end
