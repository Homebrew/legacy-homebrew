class Dpkg < Formula
  homepage "https://wiki.debian.org/Teams/Dpkg"
  url "https://mirrors.kernel.org/debian/pool/main/d/dpkg/dpkg_1.17.21.tar.xz"
  mirror "http://ftp.debian.org/debian/pool/main/d/dpkg/dpkg_1.17.21.tar.xz"
  sha256 "3ed776627181cb9c1c9ba33f94a6319084be2e9ec9c23dd61ce784c4f602cf05"

  bottle do
    sha1 "15101b6619ae657e7d59e72d30155dd6fd7498fd" => :yosemite
    sha1 "05b2f939c6b43d338dbfb83757fa358641ef7bb1" => :mavericks
    sha1 "f57689470ce7af05f25fa7a31ee158db1d0711e5" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gnu-tar"
  depends_on "xz"

  # Fixes the PERL_LIBDIR and MD5/SHA tool names & usage. Reported upstream:
  # https://lists.debian.org/debian-dpkg/2014/11/msg00024.html
  # https://lists.debian.org/debian-dpkg/2014/11/msg00027.html
  patch do
    url "https://raw.githubusercontent.com/DomT4/scripts/master/Homebrew_Resources/dpkg/dpkgosx.diff"
    sha1 "b74e5a0738bd4f6e8244d49b04ed9cb44bf5de6e"
  end

  def install
    # There was a commit merged prior to this release that forgot to add ; to the end of function lines
    # Consequently = Build failure. Put the ; in here to fix the issue.
    # Also removes a function left over from previous refactoring which causes issues now.
    # This will all be in the 1.17.22 release.
    # https://lists.debian.org/debian-dpkg/2014/11/msg00029.html
    inreplace "lib/dpkg/fdio.c" do |s|
      s.gsub! "fs_preallocate_setup(&fs, F_ALLOCATECONTIG, offset, len);", "fd_preallocate_setup(&fs, F_ALLOCATECONTIG, offset, len);"
      s.gsub! "fs_preallocate_setup(&fs, F_ALLOCATEALL, offset, len);", "fd_preallocate_setup(&fs, F_ALLOCATEALL, offset, len);"
      s.gsub! "rc = fcntl(fd, F_PREALLOCATE, &fs)", "rc = fcntl(fd, F_PREALLOCATE, &fs);"
    end

    # We need to specify a recent gnutar, otherwise various dpkg C programs will
    # use the system "tar", which will fail because it lacks certain switches.
    ENV["TAR"] = Formula["gnu-tar"].opt_bin/"gtar"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-dselect",
                          "--disable-linker-optimisations",
                          "--disable-start-stop-daemon",
                          "--disable-update-alternatives"
    system "make"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    This installation of dpkg is not configured to install software, so
    commands such as `dpkg -i`, `dpkg --configure` will fail.
    EOS
  end

  test do
    # Do not remove the empty line from the end of the control file
    # All deb control files MUST end with an empty line
    mkdir_p "test/DEBIAN"
    mkdir_p "test/data"
    touch "test/data/empty.txt"

    (testpath/"test"/"DEBIAN"/"control").write <<-EOS.undent
      Package: test
      Version: 1.40.99
      Architecture: amd64
      Description: I am a test
      Maintainer: Dpkg Developers <test@test.org>

    EOS
    system "#{bin}/dpkg", "-b", testpath/"test", "test.deb"
    assert File.exist?("test.deb")
  end
end
