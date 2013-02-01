require 'formula'

class Groovy < Formula
  homepage 'http://groovy.codehaus.org/'
  url 'http://dist.groovy.codehaus.org/distributions/groovy-binary-2.1.0.zip'
  sha1 'c54371b1ffed39986f2d2379fe6ff8f9ab9b71c2'

  def install
    # Don't need Windows files.
    # Why are icons in bin?
    rm_f Dir["bin/*.bat","bin/groovy.{icns,ico}"]

    prefix.install_metafiles
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
