require 'formula'

class AppEngineJavaSdk < Formula
  homepage 'http://code.google.com/appengine/docs/java/overview.html'
  url 'http://googleappengine.googlecode.com/files/appengine-java-sdk-1.6.6.zip'
  sha1 'bb67c8984606fc8d28ab4f49afc088b5b70d9097'

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
