require 'formula'

class Fits < Formula
  homepage 'http://fitstool.org/'
  url 'http://projects.iq.harvard.edu/files/fits/files/fits-0.8.0.zip'
  sha1 'cad95a3d457808bd18fbce798c7665e5b3ff7888'

  def install
    inreplace 'fits-env.sh' do |s|
      s.gsub!  "FITS_HOME=`echo \"$0\" | sed 's,/[^/]*$,,'`", "FITS_HOME=#{prefix}"
      s.gsub! "${FITS_HOME}/lib", libexec
    end

    prefix.install %w{ COPYING COPYING.LESSER tools xml }
    prefix.install Dir['*.txt']
    libexec.install Dir['lib/*']
    bin.install 'fits.sh' => 'fits'
    bin.install 'fits-ngserver.sh' => 'fits-ngserver'
    bin.install 'fits-env.sh'
  end
end
