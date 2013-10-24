require 'formula'

class Mksh < Formula
  homepage 'https://mirbsd.org/mksh.htm'
  url 'https://mirbsd.org/MirOS/dist/mir/mksh/mksh-R47.tgz'
  version '45.1'
  sha256 'b7159f09c551d97357b5b8a76829bfd6c668cc93f15faa92d510ad6dc0dab939'

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
