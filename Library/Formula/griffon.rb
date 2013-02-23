require 'formula'

class Griffon < Formula
  homepage 'http://griffon.codehaus.org/'
  url 'http://dist.codehaus.org/griffon/griffon/1.1.x/griffon-1.1.0-bin.zip'
  sha1 '3cb6ffa15a5bce3d3e7e2a56b210d9c40853b442'

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
