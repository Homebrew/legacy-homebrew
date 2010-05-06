require 'formula'

class AppEngineJavaSdk <Formula
  url 'http://googleappengine.googlecode.com/files/appengine-java-sdk-1.3.3.1.zip'
  homepage 'http://code.google.com/appengine/docs/java/overview.html'
  sha1 '679779193bd6760d356ff6790f31b77af7109e69'

  def shim_script target
    <<-EOS.undent
      #!/usr/bin/env bash
      cd #{libexec}/bin
      ./#{target} $*
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
