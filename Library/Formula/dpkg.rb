class Dpkg < Formula
  homepage "https://wiki.debian.org/Teams/Dpkg"
  url "https://mirrors.kernel.org/debian/pool/main/d/dpkg/dpkg_1.17.25.tar.xz"
  mirror "http://ftp.debian.org/debian/pool/main/d/dpkg/dpkg_1.17.25.tar.xz"
  sha256 "07019d38ae98fb107c79dbb3690cfadff877f153b8c4970e3a30d2e59aa66baa"

  bottle do
    sha1 "15101b6619ae657e7d59e72d30155dd6fd7498fd" => :yosemite
    sha1 "05b2f939c6b43d338dbfb83757fa358641ef7bb1" => :mavericks
    sha1 "f57689470ce7af05f25fa7a31ee158db1d0711e5" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gnu-tar"
  depends_on "xz" # For LZMA

  def install
    # Fix for OS X checksum utility names.
    inreplace "scripts/Dpkg/Checksums.pm" do |s|
      s.gsub! "md5sum", "md5"
      s.gsub! "sha1sum", "shasum"
      s.gsub! "sha256sum", "'shasum', '-a', '256'"
    end

    # We need to specify a recent gnutar, otherwise various dpkg C programs will
    # use the system "tar", which will fail because it lacks certain switches.
    ENV["TAR"] = Formula["gnu-tar"].opt_bin/"gtar"
    ENV["PERL_LIBDIR"] = lib/"perl5/site_perl"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
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
    (testpath/"test/data/homebrew.txt").write <<-EOS.undent
      Homebrew was here.
    EOS

    (testpath/"test/DEBIAN/control").write <<-EOS.undent
      Package: test
      Version: 1.40.99
      Architecture: amd64
      Description: I am a test
      Maintainer: Dpkg Developers <test@test.org>

    EOS
    system bin/"dpkg", "-b", testpath/"test", "test.deb"
    assert File.exist?("test.deb")

    rm_rf "test"
    system bin/"dpkg", "-x", "test.deb", testpath
    assert File.exist?("data/homebrew.txt")
  end
end
