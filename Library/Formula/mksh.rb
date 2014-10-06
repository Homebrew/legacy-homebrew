require 'formula'

class Mksh < Formula
  homepage 'https://mirbsd.org/mksh.htm'
  url 'http://mirbsd.org/MirOS/dist/mir/mksh/mksh-R50c.tgz'
  sha1 '64af48cca823962b96720ed8a49621aad398dd0a'

  bottle do
    cellar :any
    sha1 "372be194ac428fa9e0b9a8d0da0a61749d2d7371" => :mavericks
    sha1 "ca9e90bb5732b0f03ec46c58034face9ac598253" => :mountain_lion
    sha1 "07c5936d6df6d8808d7d99c1aa81d69a07eb9fd4" => :lion
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
