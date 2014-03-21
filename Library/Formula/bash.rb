require 'formula'

class Bash < Formula
  homepage 'http://www.gnu.org/software/bash/'

  stable do
    url "http://ftpmirror.gnu.org/bash/bash-4.3.tar.gz"
    mirror "http://ftp.gnu.org/gnu/bash/bash-4.3.tar.gz"
    sha256 "afc687a28e0e24dc21b988fa159ff9dbcf6b7caa92ade8645cc6d5605cd024d4"
    version "4.3.0"
  end

  head 'git://git.savannah.gnu.org/bash.git'

  depends_on 'readline'

  def install
    # When built with SSH_SOURCE_BASHRC, bash will source ~/.bashrc when
    # it's non-interactively from sshd.  This allows the user to set
    # environment variables prior to running the command (e.g. PATH).  The
    # /bin/bash that ships with Mac OS X defines this, and without it, some
    # things (e.g. git+ssh) will break if the user sets their default shell to
    # Homebrew's bash instead of /bin/bash.
    ENV.append_to_cflags "-DSSH_SOURCE_BASHRC"
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/opt/readline/include"
    ENV.append_to_cflags "-L#{HOMEBREW_PREFIX}/opt/readline/lib"


    system "./configure", "--prefix=#{prefix}", "--with-installed-readline"
    system "make install"
  end

  def caveats; <<-EOS.undent
    In order to use this build of bash as your login shell,
    it must be added to /etc/shells.
    EOS
  end

  test do
    output = `#{bin}/bash -c "echo hello"`.strip
    assert_equal "hello", output
    assert_equal 0, $?.exitstatus
  end
end
