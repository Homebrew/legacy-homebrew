require 'formula'

class Griffon < Formula
  homepage 'http://griffon.codehaus.org/'
  url 'http://dist.codehaus.org/griffon/griffon/0.9.x/griffon-0.9.4-bin.tgz'
  md5 'e3f7972462d47f30a2e7d3893b360489'

  def install
    rm_f Dir["bin/*.bat"]

    prefix.install %w[LICENSE README]
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats; <<-EOS.undent
    You should set the environment variable GRIFFON_HOME to
      #{libexec}
    EOS
  end
end
