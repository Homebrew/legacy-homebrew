require "formula"

class Bash < Formula
  homepage "http://www.gnu.org/software/bash/"

  stable do
    url "http://ftpmirror.gnu.org/bash/bash-4.3.tar.gz"

    mirror "http://ftp.gnu.org/gnu/bash/bash-4.3.tar.gz"
    sha256 "afc687a28e0e24dc21b988fa159ff9dbcf6b7caa92ade8645cc6d5605cd024d4"
    version "4.3.28"

    # Vendor the patches. The mirrors are unreliable for getting the patches,
    # and the more patches there are, the more unreliable they get. Upstream
    # patches can be found in: http://git.savannah.gnu.org/cgit/bash.git
    patch do
      url "https://gist.githubusercontent.com/jacknagel/c1cf23775c774e2b4b6d/raw/c163f4ec554c3aa160e963f24289765a70db37fe/bash-4.3.28.diff"
      sha1 "4d57c33e58e8dd9dbaa0df85530113f2726c96e4"
    end
  end

  bottle do
    sha1 "ab637031490cf82480c07687a9118aec6ad08cb0" => :mavericks
    sha1 "d206dc902b6acefdd383eee7506d4cbece47ce01" => :mountain_lion
    sha1 "7602fded8f0f794adf17345ca8f0d5e3017bb980" => :lion
  end

  head "git://git.savannah.gnu.org/bash.git"

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
    system "make install"
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
