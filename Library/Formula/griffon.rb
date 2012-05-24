require 'formula'

class Griffon < Formula
  homepage 'http://griffon.codehaus.org/'
  url 'http://dist.codehaus.org/griffon/griffon/0.9.x/griffon-0.9.5-bin.tgz'
  md5 '2f3f579e09c8460e7265e567582a49cc'

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
