class Bash < Formula
  desc "Bourne-Again SHell, a UNIX command interpreter"
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
    patch :p0 do
      url "https://github.com/ilovezfs/patches/raw/bash-4.3-p042/bash/bash-patches-4.3-p042.tar.gz"
      sha256 "dc8424be2ae909273596e2cab41b38b25a55405e909ae6b9b8b8b8df27bae0ec"
      apply "bash43-001",
            "bash43-002",
            "bash43-003",
            "bash43-004",
            "bash43-005",
            "bash43-006",
            "bash43-007",
            "bash43-008",
            "bash43-009",
            "bash43-010",
            "bash43-011",
            "bash43-012",
            "bash43-013",
            "bash43-014",
            "bash43-015",
            "bash43-016",
            "bash43-017",
            "bash43-018",
            "bash43-019",
            "bash43-020",
            "bash43-021",
            "bash43-022",
            "bash43-023",
            "bash43-024",
            "bash43-025",
            "bash43-026",
            "bash43-027",
            "bash43-028",
            "bash43-029",
            "bash43-030",
            "bash43-031",
            "bash43-032",
            "bash43-033",
            "bash43-034",
            "bash43-035",
            "bash43-036",
            "bash43-037",
            "bash43-038",
            "bash43-039",
            "bash43-040",
            "bash43-041",
            "bash43-042"
    end
  end

  bottle do
    sha256 "a767075b636c0964d2eca3c4f87eb679384fcd2eb7a778ea862248717f63b082" => :el_capitan
    sha256 "e4c37730749adcdbc274fa57b62300f2f2c68078b962cfd196a7e8f0764b543c" => :yosemite
    sha256 "4078f42a58506e67d25ec0f82f85efd265bf2eac606a9aeca50a7e7bd5b7e025" => :mavericks
    sha256 "4fded417b56f73ffcf48b5d05bc22e04beb521c7f91f4d6b5671876173584c27" => :mountain_lion
  end

  devel do
    url "http://ftpmirror.gnu.org/bash/bash-4.4-beta.tar.gz"
    mirror "https://ftp.gnu.org/gnu/bash/bash-4.4-beta.tar.gz"
    sha256 "8273c415b70260baaf7a9fdc9632451cd3987718fd054ee7ee13d7613808d231"
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

    if build.devel? || build.head?
      system "./configure", "--prefix=#{prefix}"
    else
      system "./configure", "--prefix=#{prefix}", "--with-installed-readline"
    end
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
