require 'formula'

class Rsense < Formula
  homepage 'http://cx4a.org/software/rsense/'
  url 'http://cx4a.org/pub/rsense/rsense-0.3.tar.bz2'
  md5 '78b6d5aeb195a01ec955f50d97fde27e'

  def startup_script(name)
    <<-EOS.undent
      #!/bin/bash
      exec "#{libexec}/bin/#{name}" "$@"
    EOS
  end

  def install
    prefix.install 'README.txt'
    libexec.install Dir['*']
    (libexec+'bin/rsense').chmod 0755
    (bin+'rsense').write startup_script('rsense')
  end

  def caveats
    <<-EOS.undent
    If this is your first install, create default config file:
        ruby #{libexec}/etc/config.rb > ~/.rsense

    You will also need to setup Emacs and/or Vim to use Rsense. Please
    refer to the User Manual: http://cx4a.org/software/rsense/manual.html
    EOS
  end

  def test
    system "#{bin}/rsense", "version"
  end
end
