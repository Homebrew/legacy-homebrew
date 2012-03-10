require 'formula'

class AppEngineJavaSdk < Formula
  homepage 'http://code.google.com/appengine/docs/java/overview.html'
  url 'http://googleappengine.googlecode.com/files/appengine-java-sdk-1.6.3.1.zip'
  sha1 '88371b07c405826117fee6ae014c353cb09e24e0'

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
