require 'formula'

class Griffon < Formula
  homepage 'http://griffon.codehaus.org/'
  url 'http://dist.codehaus.org/griffon/griffon/1.0.x/griffon-1.0.2-bin.zip'
  sha1 '1ae2b9bf9ff44c85aaff19d88c342ede139e70f6'

  def install
    rm_f Dir["bin/*.bat"]

    prefix.install %w[LICENSE README.md]
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    You should set the environment variable GRIFFON_HOME to
      #{libexec}
    EOS
  end
end
