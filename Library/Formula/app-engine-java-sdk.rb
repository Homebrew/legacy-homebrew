require 'formula'

class AppEngineJavaSdk < Formula
  url 'http://googleappengine.googlecode.com/files/appengine-java-sdk-1.5.0.1.zip'
  homepage 'http://code.google.com/appengine/docs/java/overview.html'
  sha1 'a095571c1a186d298c951098e69e0a0bffb64811'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      #{libexec}/bin/#{target} $*
    EOS
  end

  def install
    rm Dir['bin/*.cmd']
    libexec.install Dir['*']

    Dir["#{libexec}/bin/*"].each do |b|
      n = Pathname.new(b).basename
      (bin+n).write shim_script(n)
    end
  end
end
