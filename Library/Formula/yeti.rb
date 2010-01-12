require 'formula'

class Yeti <Formula
  url 'http://linux.ee/~mzz/yeti/yeti.jar'
  homepage 'http://mth.github.com/yeti/'
  md5 '1d30c9bbace011e2ccb1dcced64c89b2'
  head 'git://github.com/mth/yeti.git'
  version '082009' # Yeti doesn't do any versioning that I can see, so
                   # tracking this by date
  JAR = 'yeti.jar'

  def install
    prefix.install JAR
    (bin+'yeti').write(eval('"'+DATA.read+'"'))
  end
end

__END__
#!/bin/sh

YETI=#{prefix}/#{JAR}
java -server -jar $YETI $@
