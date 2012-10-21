require 'formula'

class AppEngineJavaSdk < Formula
  homepage 'https://developers.google.com/appengine/docs/java/overview'
  url 'http://googleappengine.googlecode.com/files/appengine-java-sdk-1.7.2.zip'
  sha1 '5adcecb9c76937de5afeb3cf1fe17a6cce24f130'

  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      "#{libexec}/bin/#{target}" "$@"
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
