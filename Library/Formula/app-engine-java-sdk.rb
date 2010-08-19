require 'formula'

class AppEngineJavaSdk <Formula
  url 'http://googleappengine.googlecode.com/files/appengine-java-sdk-1.3.6.zip'
  homepage 'http://code.google.com/appengine/docs/java/overview.html'
  sha1 '6367f12d63f641341f033ace8374c5f600d78658'

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
