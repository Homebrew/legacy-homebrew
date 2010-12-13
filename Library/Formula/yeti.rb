require 'formula'

class Yeti <Formula
  url 'http://linux.ee/~mzz/yeti/yeti.jar'
  homepage 'http://mth.github.com/yeti/'
  md5 '9be281e8b6cfe3e96f9ea95155d1dc97'
  version '2010.04' # Yeti doesn't do any versioning that I can see, so use date

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
