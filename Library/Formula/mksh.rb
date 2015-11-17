class Mksh < Formula
  desc "MirBSD Korn Shell"
  homepage "https://mirbsd.org/mksh.htm"
  url "https://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R50f.tgz"
  mirror "http://pub.allbsd.org/MirOS/dist/mir/mksh/mksh-R50f.tgz"
  sha256 "74e051ce92ece9555d91505b956572f64668fc88c5ccabee742099e7f29a2bcb"

  bottle do
    cellar :any
    sha1 "4e0335469b6ff8bf83257cda6e00bd3205fff163" => :mavericks
    sha1 "b93d25d2a9c3f606d44567a2cdf400649b7b6cf4" => :mountain_lion
    sha1 "52e7568da446b9ea44f23a39b6c6542d6e73beb1" => :lion
  end

  def install
    system "sh", "./Build.sh", "-r", "-c", (ENV.compiler == :clang ? "lto" : "combine")
    bin.install "mksh"
    man1.install "mksh.1"
  end

  def caveats; <<-EOS.undent
    To allow using mksh as a login shell, run this as root:
        echo #{HOMEBREW_PREFIX}/bin/mksh >> /etc/shells
    Then, any user may run `chsh` to change their shell.
    EOS
  end

  test do
    assert_equal "honk",
                 shell_output("mksh -c 'echo honk'").chomp
  end
end
