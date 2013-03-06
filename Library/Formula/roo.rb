require 'formula'

class Roo < Formula
  version '1.2.3.RELEASE'
  homepage 'http://www.springsource.org/spring-roo'
  url 'http://s3.amazonaws.com/dist.springframework.org/release/ROO/spring-roo-1.2.3.RELEASE.zip'
  sha1 '5980d587647ca651f90ed67ebaf0ab67212f7ee1'

  def install
    # Remove Windows scripts
    rm_rf Dir['bin/*.bat']

    # Install files
    prefix.install 'readme.txt'
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/roo.sh" => "roo"
  end

end
