require 'formula'

class Fits < Formula
  url 'http://fits.googlecode.com/files/fits-0.6.0.zip'
  homepage 'http://code.google.com/p/fits/'
  md5 '354eaba6c83f8403b36e4dee3f67224e'

  def install
    inreplace 'fits.sh' do |s|
      s.gsub!  "FITS_HOME=`echo \"$0\" | sed 's,/[^/]*$,,'`", "FITS_HOME=#{prefix}"
      s.gsub! "${FITS_HOME}/lib", libexec
    end

    prefix.install %w{ COPYING COPYING.LESSER tools xml }
    prefix.install Dir['*.txt']
    libexec.install Dir['lib/*']
    bin.install 'fits.sh' => 'fits'
  end
end
