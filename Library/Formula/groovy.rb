require 'formula'

class Groovy < Formula
  homepage 'http://groovy.codehaus.org/'
  url 'http://dist.groovy.codehaus.org/distributions/groovy-binary-1.8.6.zip'
  md5 'e62d2f9c2c4d528b8a0eb49cdfb389ae'

  devel do
    url 'http://dist.groovy.codehaus.org/distributions/groovy-binary-2.0.0-rc-2.zip'
    version '2.0.0-rc-2'
    md5 '13a8277137561596a8ff8bbd15b842b2'
  end

  def install
    # Don't need Windows files.
    # Why are icons in bin?
    rm_f Dir["bin/*.bat","bin/groovy.{icns,ico}"]

    prefix.install %w(LICENSE.txt NOTICE.txt)
    libexec.install %w(bin conf lib embeddable)
    lib.install "indy" if ARGV.build_devel?
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<-EOS.undent
      You should set the environment variable GROOVY_HOME to
        #{libexec}
    EOS
  end
end
