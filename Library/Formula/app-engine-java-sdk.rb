require 'formula'

class AppEngineJavaSdk <Formula
  url 'http://googleappengine.googlecode.com/files/appengine-java-sdk-1.3.4.zip'
  homepage 'http://code.google.com/appengine/docs/java/overview.html'
  sha1 '2fd5ae278c94d187f4ff4db5b572e3d26f6fcce7'

  def shim_script target
    <<-EOS.undent
      #!/usr/bin/env bash
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
