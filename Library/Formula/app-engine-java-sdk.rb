require 'formula'

class AppEngineJavaSdk < Formula
  url 'http://googleappengine.googlecode.com/files/appengine-java-sdk-1.6.0.zip'
  homepage 'http://code.google.com/appengine/docs/java/overview.html'
  sha1 '7bb7e429b85c7cb6bfbeddd2c3d74b5982db988c'

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
