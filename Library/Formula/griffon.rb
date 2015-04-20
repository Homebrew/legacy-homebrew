require 'formula'

class Griffon < Formula
  homepage 'http://griffon.codehaus.org/'
  url 'http://dl.bintray.com/content/aalmiray/Griffon/griffon-1.5.0-bin.tgz'
  sha1 'de28b792c37cf103b5745f2f323403ec6990c58a'

  def install
    rm_f Dir["bin/*.bat"]

    prefix.install_metafiles
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    You should set the environment variable GRIFFON_HOME to:
      #{libexec}
    EOS
  end
end
