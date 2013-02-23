require 'formula'

class Bagit < Formula
  homepage 'http://sourceforge.net/projects/loc-xferutils/files/loc-bil-java-library/4.4/'
  url 'http://sourceforge.net/projects/loc-xferutils/files/loc-bil-java-library/4.4/bagit-4.4-bin.zip'
  sha1 '2ef049e2d53a0cbb8e9959a6e2433d82a2c0c11b'

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
