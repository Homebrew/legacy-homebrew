require 'formula'

class PaxConstruct < Formula
  homepage 'http://wiki.ops4j.org/display/paxconstruct/Pax+Construct'
  url 'http://repo1.maven.org/maven2/org/ops4j/pax/construct/scripts/1.5/scripts-1.5.zip'
  sha1 'af7bf6d6ab4947e1b38a33e89fb1d2dbfe4ad864'

  def install
    rm_rf Dir['bin/*.bat']
    prefix.install_metafiles 'bin' # Don't put these in bin!
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end
end
