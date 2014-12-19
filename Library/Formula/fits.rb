require 'formula'

class Fits < Formula
  homepage 'http://fitstool.org/'
  url 'http://projects.iq.harvard.edu/files/fits/files/fits-0.8.2.zip'
  sha1 'ea4a6020f9d64a4c9b85f37b488aa254c10e2703'

  # provided jars may not be compatible with installed java,
  # but works when built from source
  depends_on "ant" => :build

  def install
    system "ant"

    inreplace 'fits-env.sh' do |s|
      s.gsub!  "FITS_HOME=`echo \"$0\" | sed 's,/[^/]*$,,'`", "FITS_HOME=#{prefix}"
      s.gsub! "${FITS_HOME}/lib", libexec
    end

    prefix.install %w{ COPYING COPYING.LESSER tools xml }
    prefix.install Dir['*.txt']
    libexec.install Dir['lib/*']

    # fits-env.sh is a helper script that sets up environment
    # variables, so we want to tuck this away in libexec
    libexec.install 'fits-env.sh'
    inreplace %w[fits.sh fits-ngserver.sh],
      '"$(dirname $BASH_SOURCE)/fits-env.sh"', "'#{libexec}/fits-env.sh'"

    bin.install 'fits.sh' => 'fits'
    bin.install 'fits-ngserver.sh' => 'fits-ngserver'
  end
end
