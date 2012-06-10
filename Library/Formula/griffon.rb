require 'formula'

class Griffon < Formula
  homepage 'http://griffon.codehaus.org/'
  url 'http://dist.codehaus.org/griffon/griffon/1.0.x/griffon-1.0.0-bin.zip'
  md5 'cdb95cb96651a5a466ff3fe7b738684e'

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
