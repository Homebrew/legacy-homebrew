require 'formula'

class Fits < Formula
  homepage 'http://code.google.com/p/fits/'
  url 'http://fits.googlecode.com/files/fits-0.6.2.zip'
  sha1 '92e3b6c869288152fde8ae1266e5d23c9ef55680'

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
