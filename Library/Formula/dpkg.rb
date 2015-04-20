class Dpkg < Formula
  homepage "https://wiki.debian.org/Teams/Dpkg"
  url "https://mirrors.kernel.org/debian/pool/main/d/dpkg/dpkg_1.17.25.tar.xz"
  mirror "http://ftp.debian.org/debian/pool/main/d/dpkg/dpkg_1.17.25.tar.xz"
  sha256 "07019d38ae98fb107c79dbb3690cfadff877f153b8c4970e3a30d2e59aa66baa"

  bottle do
    sha256 "7c0ce804c160ee36c1328365f2e2921a7ace51a908dde2bf41f8c0ca7592ce9b" => :yosemite
    sha256 "5de02303b6d3e2842feb1a836fbf4ee6b6d5886a2cb9013d8158273cae753cfa" => :mavericks
    sha256 "d9855d5f78de6bc75a883f4fe04ea61152fea560554b27121ed76cec27fff8e5" => :mountain_lion
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
