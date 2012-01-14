require 'formula'

class Mksh < Formula
  url 'https://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R40d.cpio.gz'
  homepage 'https://www.mirbsd.org/mksh.htm'
  md5 'c6428401103367730a95b99284bf47dc'
  version '0.40d'

  def install
    system 'sh ./Build.sh -combine'
    bin.install 'mksh'
    man1.install 'mksh.1'
  end

  def caveats; <<-EOS.undent
    To allow using mksh as a login shell, run this as root:
        echo #{HOMEBREW_PREFIX}/bin/mksh >> /etc/shells
    Then, any user may run
        chsh
    to change their shell.
    EOS
  end
end
