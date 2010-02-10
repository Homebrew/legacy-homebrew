require 'formula'

EXEC=<<EOS
#!/bin/bash
java -jar xxx/LanguageTool.jar $*
EOS

class Languagetool <Formula
  url 'http://www.languagetool.org/download/LanguageTool-1.0.0.oxt'
  homepage 'http://www.languagetool.org/'
  md5 '979b1a1f2ce3a9100d7aa7b1ef245734'

  def install
    File.open("languagetool", 'w') {|f| f.write EXEC}
    inreplace "languagetool", "xxx", "#{share}"
    bin.install "languagetool"
    Dir["*"].each {|f| share.install f}
  end
end
