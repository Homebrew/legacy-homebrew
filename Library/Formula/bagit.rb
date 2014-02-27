require 'formula'

class Bagit < Formula
  homepage 'https://github.com/LibraryOfCongress/bagit-java'
  url 'https://github.com/LibraryOfCongress/bagit-java/releases/download/bagit-4.8.1/bagit-4.8.1-bin.zip'
  sha1 'a5f42372dcbe75f44d9181dd8edc8e6f18b68ec9'

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
