require 'formula'

class Groovy < Formula
  homepage 'http://groovy.codehaus.org/'
  url 'http://dist.groovy.codehaus.org/distributions/groovy-binary-2.0.1.zip'
  sha1 '8368651e4c96e2ab272d2a0623861c817d947316'

  def install
    # Don't need Windows files.
    # Why are icons in bin?
    rm_f Dir["bin/*.bat","bin/groovy.{icns,ico}"]

    prefix.install %w(LICENSE.txt NOTICE.txt)
    libexec.install %w(bin conf lib embeddable)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<-EOS.undent
      You should set the environment variable GROOVY_HOME to
        #{libexec}
    EOS
  end
end
