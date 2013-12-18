require 'formula'

class Griffon < Formula
  homepage 'http://griffon.codehaus.org/'
  url 'http://dl.bintray.com/content/aalmiray/Griffon/griffon-1.4.0-bin.tgz'
  sha1 'a2cc25cf95388739929ad09800be9568ac02bab2'

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
