require 'formula'

class Bagit < Formula
  homepage 'http://sourceforge.net/projects/loc-xferutils/files/loc-bil-java-library/4.1/'
  url 'http://downloads.sourceforge.net/project/loc-xferutils/loc-bil-java-library/4.1/bagit-4.1-bin.zip'
  md5 '9c104028d608edb41a9b78eeb0662411'

  skip_clean 'logs'

  def install
    prefix.install %w{conf logs}

    libexec.install Dir['lib/*']

    # Point to libexec, and move conf file
    inreplace "bin/bag" do |s|
      s.gsub! "$APP_HOME/lib", "$APP_HOME/libexec"
      s.gsub! "/bin/$APP_NAME.classworlds.conf", "/conf/$APP_NAME.classworlds.conf"
    end
    inreplace "bin/bag.classworlds.conf", "${app.home}/lib", "${app.home}/libexec"

    bin.install 'bin/bag'
    (prefix+'conf').install 'bin/bag.classworlds.conf'
  end
end
