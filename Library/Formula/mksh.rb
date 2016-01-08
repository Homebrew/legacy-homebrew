class Mksh < Formula
  desc "MirBSD Korn Shell"
  homepage "https://www.mirbsd.org/mksh.htm"
  url "https://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R51.tgz"
  mirror "http://pub.allbsd.org/MirOS/dist/mir/mksh/mksh-R51.tgz"
  sha256 "9feeaa5ff33d8199c0123675dec29785943ffc67152d58d431802bc20765dadf"

  bottle do
    cellar :any_skip_relocation
    sha256 "e0535cfd7418370c6292a2dc0d26afce8008c6cd2c2915798d1bfd7e96df9087" => :el_capitan
    sha256 "1ec672da1a859bdb7138b11e2cbf71a24272e2bc673f11d783401bbb35feea2e" => :yosemite
    sha256 "5d0a11d6cefb9dc4c54a88adc7b5dd204449d8aadaa716c170a41cd4dc3dbbe9" => :mavericks
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
