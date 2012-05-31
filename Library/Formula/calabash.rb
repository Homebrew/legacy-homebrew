require 'formula'

class Calabash < Formula
  homepage 'http://xmlcalabash.com'
  url 'http://xmlcalabash.com/download/calabash-1.0.2-94.zip'
  md5 '76e3c709ce013ab77f5e09bb8a41bd5b'
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
    system "#{bin}/calabash", "#{libexec}/xpl/pipe.xpl"
  end
end
