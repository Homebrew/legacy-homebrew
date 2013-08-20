require 'formula'

class Mksh < Formula
  homepage 'https://mirbsd.org/mksh.htm'
  url 'https://mirbsd.org/MirOS/dist/mir/mksh/mksh-R48.tgz'
  version '48.1'
  sha256 '56f6578073a669e33ced5364e0939ed6ccdb32db054489d4070afbefa36d2c73'

  def install
    system "sh", "./Build.sh", "-r", "-c", (ENV.compiler == :clang ? "lto" : "combine")
    bin.install 'mksh'
    man1.install 'mksh.1'
  end

  def caveats; <<-EOS.undent
    To allow using mksh as a login shell, run this as root:
        echo #{HOMEBREW_PREFIX}/bin/mksh >> /etc/shells
    Then, any user may run `chsh` to change their shell.
    EOS
  end
end
