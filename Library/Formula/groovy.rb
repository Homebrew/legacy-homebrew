require 'formula'

class Groovy < Formula
  homepage 'http://groovy.codehaus.org/'
  url 'http://dist.groovy.codehaus.org/distributions/groovy-binary-1.8.6.zip'
  sha1 '470fd9b2ea4f2cf405b8a71d92e7a8a4753b1a8c'

  devel do
    url 'http://dist.groovy.codehaus.org/distributions/groovy-binary-2.0.0-rc-4.zip'
    version '2.0.0-rc-4'
    sha1 '1bfb33e14736bad6c99ba08014c16c89f5bd100a'
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
