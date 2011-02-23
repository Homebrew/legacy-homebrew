require 'formula'

class Yeti <Formula
  url 'http://linux.ee/~mzz/yeti/yeti.jar'
  homepage 'http://mth.github.com/yeti/'
  md5 '4b1ef8dfa760224c061c3b0b98b2ea8c'
  version '2011.02' # Yeti doesn't do any versioning that I can see, so use date

  head 'git://github.com/mth/yeti.git'

  def install
    prefix.install "yeti.jar"
    (bin+'yeti').write <<-EOS
#!/bin/sh
YETI=#{prefix}/yeti.jar
java -server -jar $YETI $@
EOS
  end
end
