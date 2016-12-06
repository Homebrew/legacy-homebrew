require 'formula'


class Crash < Formula
  homepage 'http://vietj.github.com/crash/'
  url 'http://crsh.googlecode.com/files/crsh-1.0.0.tar.gz'
  md5 '568e43affde5feca3e4c8b20a53fad95'
  version '1.0.0'

  def install
    # Install 
    libexec.install Dir['crash/*']

    doc.install Dir['doc/*']
    # Symlink binaries
    bin.install_symlink Dir["#{libexec}/bin/crash.sh"]
  end

end
