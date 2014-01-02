require 'formula'

class Ditaa < Formula
  homepage 'http://ditaa.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ditaa/ditaa/0.9/ditaa0_9.zip'
  sha1 '3efe5a3710627e19a414c305c82f0e58adf7c4f2'

  def install
    libexec.install "ditaa0_9.jar"
    bin.write_jar_script libexec/'ditaa0_9.jar', 'ditaa'
  end
end
