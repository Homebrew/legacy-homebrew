require 'formula'

class Ditaa < Formula
  url 'http://downloads.sourceforge.net/project/ditaa/ditaa/0.9/ditaa0_9.zip'
  homepage 'http://ditaa.sourceforge.net/'
  md5 '23f2e5ede60ef7763309c08addca071a'

  def jar
    'ditaa0_9.jar'
  end

  def script
<<-EOS
#!/bin/sh
# A wrapper for ditaa.

java -jar #{prefix}/#{jar} "$@"
EOS
  end

  def install
    prefix.install jar
    (bin+'ditaa').write script
  end
end
