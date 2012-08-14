require 'formula'

class Crash < Formula
  homepage 'http://vietj.github.com/crash/'
  url 'https://crsh.googlecode.com/files/crsh-all-1.1.0.tar.gz'
  sha1 'c7a331de9fcf036197b018b509d32322c785cc11'

  def install
    libexec.install Dir['crash/*']
    doc.install Dir['doc/*']
    bin.install_symlink "#{libexec}/bin/crash.sh"
  end
end
