class Bash < Formula
  homepage "https://www.gnu.org/software/bash/"

  stable do
    url "http://ftpmirror.gnu.org/bash/bash-4.3.tar.gz"
    mirror "https://ftp.gnu.org/gnu/bash/bash-4.3.tar.gz"
    sha256 "afc687a28e0e24dc21b988fa159ff9dbcf6b7caa92ade8645cc6d5605cd024d4"
    version "4.3.33"

    # Vendor the patches. The mirrors are unreliable for getting the patches,
    # and the more patches there are, the more unreliable they get. Upstream
    # patches can be found in: http://git.savannah.gnu.org/cgit/bash.git
    patch do
      url "https://gist.githubusercontent.com/jacknagel/c1cf23775c774e2b4b6d/raw/838118bf0e07dcde8a552cb8556600b7e453d4ac/bash-4.3.33.diff"
      sha1 "71fc36bced0d15a2c221cfcbff02ea412d4bf5fa"
    end
  end

  bottle do
    sha1 "90cb996eec0339748d484b6c9634291040e5465d" => :mavericks
    sha1 "d58702a5c70288a53369068bf1e45be31fa1bf34" => :mountain_lion
    sha1 "b3fbee0555740fe7b0331f9418df807004adf7aa" => :lion
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
