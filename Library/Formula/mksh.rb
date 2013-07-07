require 'formula'

class Mksh < Formula
  homepage 'https://mirbsd.org/mksh.htm'
  url 'https://mirbsd.org/MirOS/dist/mir/mksh/mksh-R45.tgz'
  version '45.1'
  sha256 '90137336a836ad180c6e4f84065b993414aacb2e954afeac506cefb51d432cb8'

  def install
    system "sh", "./Build.sh", "-c", (ENV.compiler == :clang ? "lto" : "combine")
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
