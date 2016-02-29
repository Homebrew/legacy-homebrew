class Fits < Formula
  desc "File Information Tool Set"
  homepage "https://projects.iq.harvard.edu/fits"
  url "https://projects.iq.harvard.edu/files/fits/files/fits-0.8.6_1.zip"
  version "0.8.6-1"
  sha256 "d45f67a2606aaa0fdcbbade576f70f1590916b043fec28dcfdef1a8242fd4040"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6a3308ead5d286ec2b53c3e3dbe82ce95b712eb106926eb0a75a16a19bc84ff" => :el_capitan
    sha256 "cbd107b9147e58be56405d04b83e7b58b2a61210f8713f32ef0aa12cc0cb9192" => :yosemite
    sha256 "81b380fb42b2f057f80842a723a30bee313ca6c7f70a9f007a206c63064ca665" => :mavericks
    sha256 "be677363eb1d07b255dd6d931b372411011576d97269f75c52dbb72a716ea919" => :mountain_lion
  end

  # provided jars may not be compatible with installed java,
  # but works when built from source
  depends_on "ant" => :build
  depends_on :java => "1.7+"

  def install
    system "ant"

    inreplace "fits-env.sh" do |s|
      s.gsub! "FITS_HOME=`echo \"$0\" | sed 's,/[^/]*$,,'`", "FITS_HOME=#{prefix}"
      s.gsub! "${FITS_HOME}/lib", libexec
    end

    prefix.install %w[COPYING COPYING.LESSER tools xml]
    prefix.install Dir["*.txt"]
    libexec.install Dir["lib/*"]

    # fits-env.sh is a helper script that sets up environment
    # variables, so we want to tuck this away in libexec
    libexec.install "fits-env.sh"
    inreplace %w[fits.sh fits-ngserver.sh],
      '"$(dirname $BASH_SOURCE)/fits-env.sh"', "'#{libexec}/fits-env.sh'"

    bin.install "fits.sh" => "fits"
    bin.install "fits-ngserver.sh" => "fits-ngserver"
  end

  test do
    assert_match 'mimetype="audio/mpeg"',
      shell_output("#{bin}/fits -i #{test_fixtures "test.mp3"} 2>&1")
  end
end
