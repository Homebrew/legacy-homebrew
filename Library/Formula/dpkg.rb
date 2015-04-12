class Dpkg < Formula
  homepage "https://wiki.debian.org/Teams/Dpkg"
  url "https://mirrors.kernel.org/debian/pool/main/d/dpkg/dpkg_1.17.23.tar.xz"
  mirror "http://ftp.debian.org/debian/pool/main/d/dpkg/dpkg_1.17.23.tar.xz"
  sha256 "90c4af92fc248a7542cf6db1141d69b042130abd82781943b3c2608e78f860b5"

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
    # We need to specify a recent gnutar, otherwise various dpkg C programs will
    # use the system "tar", which will fail because it lacks certain switches.
    ENV["TAR"] = Formula["gnu-tar"].opt_bin/"gtar"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-dselect",
                          "--disable-linker-optimisations",
                          "--disable-start-stop-daemon"
    system "make"
    system "make", "install"

    (buildpath/"dummy").write "Vendor: dummy\n"
    (etc/"dpkg/origins").install "dummy"
    (etc/"dpkg/origins").install_symlink "dummy" => "default"
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
