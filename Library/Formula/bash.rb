class Bash < Formula
  desc "Bash (Bourne-again SHell) is a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"

  stable do
    url "http://ftpmirror.gnu.org/bash/bash-4.3.tar.gz"
    mirror "https://ftp.gnu.org/gnu/bash/bash-4.3.tar.gz"
    sha256 "afc687a28e0e24dc21b988fa159ff9dbcf6b7caa92ade8645cc6d5605cd024d4"
    version "4.3.39"

    # Vendor the patches. The mirrors are unreliable for getting the patches,
    # and the more patches there are, the more unreliable they get. Upstream
    # patches can be found in: http://git.savannah.gnu.org/cgit/bash.git
    patch do
      url "https://gist.githubusercontent.com/dunn/6d64e94f36a4e2416bab/raw/ed7e7fe6e1111d88f5f987a7201de48cfe461a3b/bash-4.3.39.diff"
      sha256 "9fe461b0d461a3918b32a0fed3bcfef4c2e774e0f867730a1bbfa8d510cfbcfd"
    end
  end

  head "http://git.savannah.gnu.org/r/bash.git"

  bottle do
    sha1 "1cc6e02daae58e10da97078702bc28e8f0c56adf" => :yosemite
    sha1 "d22fc7bad782868c96b5879534915bfcd8d4116d" => :mavericks
    sha1 "b4fcec9a0f33d2dd2bb375cbf83d46e6f88bf982" => :mountain_lion
  end

  depends_on "readline"

  def install
    # When built with SSH_SOURCE_BASHRC, bash will source ~/.bashrc when
    # it's non-interactively from sshd.  This allows the user to set
    # environment variables prior to running the command (e.g. PATH).  The
    # /bin/bash that ships with Mac OS X defines this, and without it, some
    # things (e.g. git+ssh) will break if the user sets their default shell to
    # Homebrew's bash instead of /bin/bash.
    ENV.append_to_cflags "-DSSH_SOURCE_BASHRC"

    system "./configure", "--prefix=#{prefix}", "--with-installed-readline"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    In order to use this build of bash as your login shell,
    it must be added to /etc/shells.
    EOS
  end

  test do
    assert_equal "hello", shell_output("#{bin}/bash -c \"echo hello\"").strip
  end
end
