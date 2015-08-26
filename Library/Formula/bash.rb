class Bash < Formula
  desc "Bash (Bourne-again SHell) is a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"

  head "http://git.savannah.gnu.org/r/bash.git"

  stable do
    url "http://ftpmirror.gnu.org/bash/bash-4.3.tar.gz"
    mirror "https://ftp.gnu.org/gnu/bash/bash-4.3.tar.gz"
    sha256 "afc687a28e0e24dc21b988fa159ff9dbcf6b7caa92ade8645cc6d5605cd024d4"
    version "4.3.42"

    # Vendor the patches. The mirrors are unreliable for getting the patches,
    # and the more patches there are, the more unreliable they get. Upstream
    # patches can be found in: http://git.savannah.gnu.org/cgit/bash.git
    patch do
      url "https://gist.githubusercontent.com/dunn/a8986687991b57eb3b25/raw/76dd864812e821816f4b1c18e3333c8fced3919b/bash-4.3.42.diff"
      sha256 "2eeb9b3ed71f1e13292c2212b6b8036bc258c58ec9c82eec7a86a091b05b15d2"
    end
  end

  bottle do
    sha256 "ee7ba6eec21b7ff28f7f4af4aa61410e898a332a962890ba427ababff461b476" => :yosemite
    sha256 "cd77ab76ba9669e9aaa7530d3f8050af402e5216093ac5d601d0bc1e71243ced" => :mavericks
    sha256 "d02261c71893bcde61fb1b1c84b49e0e7d60df9fd62b4d5af76afd1f4b29de7e" => :mountain_lion
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
