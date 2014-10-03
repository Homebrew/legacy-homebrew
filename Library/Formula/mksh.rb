require 'formula'

class Mksh < Formula
  homepage 'https://mirbsd.org/mksh.htm'
  url 'http://mirbsd.org/MirOS/dist/mir/mksh/mksh-R50c.tgz'
  sha1 '64af48cca823962b96720ed8a49621aad398dd0a'

  bottle do
    cellar :any
    sha1 "b643e1c9418f9bb4f46487d4351c43aa9195f094" => :mavericks
    sha1 "f274f48e9e8d7fc29cb4f018d733ffe43e696fb0" => :mountain_lion
    sha1 "35c935b1912d577e04e4090b59080ba7f4cb204d" => :lion
  end

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
