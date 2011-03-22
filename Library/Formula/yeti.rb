require 'formula'

class Yeti < Formula
  url 'http://linux.ee/~mzz/yeti/yeti.jar'
  homepage 'http://mth.github.com/yeti/'
  md5 'bff76dd83376c8d5828c1e813c2d774a'
  version '2011.03' # Yeti doesn't do any versioning that I can see, so use date

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
