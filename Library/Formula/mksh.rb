require 'formula'

class Mksh < Formula
  url 'https://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R40c.cpio.gz'
  homepage 'https://www.mirbsd.org/mksh.htm'
  md5 '43a79f721091833bdab3d00fbfe54a14'
  version '0.40c'

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
