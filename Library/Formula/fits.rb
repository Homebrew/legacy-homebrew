require 'formula'

class Fits < Formula
  desc "File Information Tool Set"
  homepage 'http://fitstool.org/'
  url 'http://projects.iq.harvard.edu/files/fits/files/fits-0.8.4_0.zip'
  version '0.8.4'
  sha1 'f9b6b13cf1e818c6cdcfec71eb3dcd6804dd8819'

  bottle do
    cellar :any
    sha256 "e606253277eb78b26d24ff3dfd582d7bc1fae03d13e393ff0512885fdc278066" => :yosemite
    sha256 "0e97437daf0e227b2ec937cf9034db585a92a17e34cd22ed2f8fe2b80be15003" => :mavericks
    sha256 "050cb99d9da1f008a4721c5e3cf962a19fc591f075e6126b9d2bea7482495dfd" => :mountain_lion
  end

  # provided jars may not be compatible with installed java,
  # but works when built from source
  depends_on "ant" => :build
  depends_on :java => "1.8"

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
