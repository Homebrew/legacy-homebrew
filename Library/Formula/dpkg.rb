class Dpkg < Formula
  desc "Debian package management system"
  homepage "https://wiki.debian.org/Teams/Dpkg"
  url "https://mirrors.kernel.org/debian/pool/main/d/dpkg/dpkg_1.18.1.tar.xz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/d/dpkg/dpkg_1.18.1.tar.xz"
  sha256 "cb26a97ca21c970cbe63a762125fe21f7437663badf6ce686589fe62650399da"

  bottle do
    sha256 "522f15cfe5c06fc1a8dd2c78a247d047997d6f52b5d5ccbddf49eb90c7e376bc" => :yosemite
    sha256 "555fae1311e404df2cb0d7033a6c1f2f621f70a6489013f2b43282ca5b31d925" => :mavericks
    sha256 "ccf777e535ba586b6781daffbfd61fe236557819b969687b11bfec1d991d2e2d" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gnu-tar"
  depends_on "xz" # For LZMA

  def install
    # We need to specify a recent gnutar, otherwise various dpkg C programs will
    # use the system "tar", which will fail because it lacks certain switches.
    ENV["TAR"] = Formula["gnu-tar"].opt_bin/"gtar"

    # Theoretically, we could reinsert a patch here submitted upstream previously
    # but the check for PERL_LIB remains in place and incompatible with Homebrew.
    # Using an env and scripting is a solution less likely to break over time.
    # Both variables need to be set. One is compile-time, the other run-time.
    ENV["PERL_LIBDIR"] = libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{libexec}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-dselect",
                          "--disable-linker-optimisations",
                          "--disable-start-stop-daemon"
    system "make"
    system "make", "install"

    bin.install Dir["#{libexec}/bin/*"]
    man.install Dir["#{libexec}/share/man/*"]
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])

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
