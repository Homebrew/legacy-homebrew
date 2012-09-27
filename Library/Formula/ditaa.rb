require 'formula'

class Ditaa < Formula
  url 'http://downloads.sourceforge.net/project/ditaa/ditaa/0.9/ditaa0_9.zip'
  homepage 'http://ditaa.sourceforge.net/'
  sha1 '3efe5a3710627e19a414c305c82f0e58adf7c4f2'

  def install
    prefix.install "ditaa0_9.jar"
    (bin+'ditaa').write <<-EOS.undent
      #!/bin/sh
      java -jar "#{prefix}/ditaa0_9.jar" "$@"
    EOS
  end
end
