require 'formula'

class Yeti <Formula
  homepage 'http://mth.github.com/yeti/'
  md5 'd11756e552d0a15a007ed3403d0d86e1'
  head 'git://github.com/mth/yeti.git'
  version 'HEAD'
  JAR = 'yeti.jar'

  def install
    system '/usr/bin/ant'
    system '/usr/bin/ant jar'
    prefix.install JAR

    (bin+'yeti').write(eval('"'+DATA.read+'"'))
  end
end

__END__
#!/bin/sh

YETI=#{prefix}/#{JAR}
java -server -jar $YETI $@
