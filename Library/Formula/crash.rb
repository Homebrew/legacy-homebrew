require 'formula'

class Crash < Formula
  homepage 'http://vietj.github.io/crash/'
  url 'https://crsh.googlecode.com/files/crash-1.2.5.tar.gz'
  sha1 '8567aa4f16e47aca7041f0e48ebcbc88a038c308'

  def install
    libexec.install Dir['crash/*']
    doc.install Dir['doc/*']
    bin.install_symlink "#{libexec}/bin/crash.sh"
  end
end
