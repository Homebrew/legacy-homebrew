require 'formula'


class Crash < Formula
  homepage 'http://vietj.github.com/crash/'
  url 'http://crsh.googlecode.com/files/crsh-1.0.0-cr2.tar.gz'
  md5 '3dece12afa54044b575a7a54d04ac12d'
  version '1.0.0-cr2'

  def install
    # Install 
    libexec.install Dir['crash/*']

    doc.install Dir['doc/*']
    # Symlink binaries
    bin.install_symlink Dir["#{libexec}/bin/crash.sh"]
  end

end
