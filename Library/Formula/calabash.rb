require 'formula'

class Calabash < Formula
  homepage 'http://xmlcalabash.com'
  url 'http://xmlcalabash.com/download/calabash-1.0.0-94.zip'
  md5 '2adcfd89f8ed17a5be5b22002b35350a'
  head 'https://github.com/ndw/xmlcalabash1.git'

  depends_on 'saxon'

  def install
    libexec.install Dir["*"]
    (bin+'calabash').write shim_script('calabash')
  end

  def shim_script target
    <<-EOS.undent
      #!/usr/bin/env bash
      java -Xmx1024m -jar #{libexec}/calabash.jar "$@"
    EOS
  end

  def test
    # This small XML pipeline (*.xpl) that comes with Calabash
    # is basically its equivalent "Hello World" program.
    system "#{bin}/calabash #{self.prefix}/libexec/xpl/pipe.xpl"
  end
end
