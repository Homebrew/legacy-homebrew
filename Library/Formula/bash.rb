require "formula"

class Bash < Formula
  homepage "http://www.gnu.org/software/bash/"

  stable do
    url "http://ftpmirror.gnu.org/bash/bash-4.3.tar.gz"

    mirror "http://ftp.gnu.org/gnu/bash/bash-4.3.tar.gz"
    sha256 "afc687a28e0e24dc21b988fa159ff9dbcf6b7caa92ade8645cc6d5605cd024d4"
    version "4.3.27"

    # Vendor the patches. The mirrors are unreliable for getting the patches,
    # and the more patches there are, the more unreliable they get. Upstream
    # patches can be found in: http://git.savannah.gnu.org/cgit/bash.git
    patch do
      url "https://gist.githubusercontent.com/jacknagel/c1cf23775c774e2b4b6d/raw/c034a6a63bd5b8112d1ed390e606bc96de3f52d5/bash-4.3.27.diff"
      sha1 "ad64ab32da31506d0ef662cfa37523a7f82d1d2e"
    end
  end

  bottle do
    sha1 "498854a9cd4511e738a5e50a5532b6e698894dd7" => :mavericks
    sha1 "7582ffd8bc7e9124070e6ec38e02ddae54d93a66" => :mountain_lion
    sha1 "ffdb3be7e26c13622240b8dc3339b9b4e6c93b9f" => :lion
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
