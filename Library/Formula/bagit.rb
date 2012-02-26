require 'formula'

class Bagit < Formula
  homepage 'http://sourceforge.net/projects/loc-xferutils/files/loc-bil-java-library/4.1/'
  url 'http://downloads.sourceforge.net/project/loc-xferutils/loc-bil-java-library/4.1/bagit-4.1-bin.zip'
  md5 '9c104028d608edb41a9b78eeb0662411'

  skip_clean 'logs'

  def install
    prefix.install %w{conf logs}
    libexec.install Dir['lib/*']
    inreplace "bin/bag", "$APP_HOME/lib", "$APP_HOME/libexec"
    inreplace "bin/bag.classworlds.conf", "${app.home}/lib", "${app.home}/libexec"
    rm "bin/bag.bat"
    bin.install Dir['bin/*']
  end
end
