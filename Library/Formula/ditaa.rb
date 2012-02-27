require 'formula'

class Ditaa < Formula
  url 'http://downloads.sourceforge.net/project/ditaa/ditaa/0.9/ditaa0_9.zip'
  homepage 'http://ditaa.sourceforge.net/'
  md5 '23f2e5ede60ef7763309c08addca071a'

  def install
    prefix.install "ditaa0_9.jar"
    (bin+'ditaa').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{prefix}/ditaa0_9.jar" "$@"
    EOS
  end
end
