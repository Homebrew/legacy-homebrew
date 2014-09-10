require 'formula'

class Mksh < Formula
  homepage 'https://mirbsd.org/mksh.htm'
  url 'http://mirbsd.org/MirOS/dist/mir/mksh/mksh-R50b.tgz'
  sha1 '5554d18126eb861caa71891d6a135014b9aabb99'

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
