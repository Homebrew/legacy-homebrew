require 'formula'

class Fits < Formula
  homepage 'http://code.google.com/p/fits/'
  url 'http://fits.googlecode.com/files/fits-0.6.1.zip'
  sha1 '528be5e8d68c468ea1ea45c4812c15da8f52e9f4'

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
