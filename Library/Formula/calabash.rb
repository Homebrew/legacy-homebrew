require 'formula'

class Calabash < Formula
  homepage 'http://xmlcalabash.com'
  url 'http://xmlcalabash.com/download/calabash-1.0.2-94.zip'
  #md5 '2adcfd89f8ed17a5be5b22002b35350a'
  sha1 '70df18791244219a1b967b9759d6c9cbe567f546'
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
    system "calabash #{self.prefix}/libexec/xpl/pipe.xpl"
  end
end 