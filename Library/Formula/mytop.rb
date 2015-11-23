class Mytop < Formula
  desc "Top-like query monitor for MySQL"
  homepage "http://www.mysqlfanboy.com/mytop-3/"
  # URL & homepage down since at least ~November 2015.
  # url "http://www.mysqlfanboy.com/mytop-3/mytop-1.9.1.tar.gz"
  url "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/m/mytop/mytop_1.9.1.orig.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/mytop/mytop_1.9.1.orig.tar.gz"
  sha256 "179d79459d0013ab9cea2040a41c49a79822162d6e64a7a85f84cdc44828145e"
  revision 1

  bottle do
    cellar :any
    sha256 "1208f12adb4cee930f856bf985a8091dee5d1b6cfd319bf3ddb9a7304c9e8d76" => :el_capitan
    sha256 "3d50646b72aec1b32204e77fba3183dd9a44e2d73aa8a15bbff64f0d0eaae425" => :yosemite
    sha256 "28144af40340021ac1fb1449a918a5bfe5f15f2b3856be5486e298d5f58ed721" => :mavericks
  end

  depends_on :mysql
  depends_on "openssl"

  conflicts_with "mariadb", :because => "both install `mytop` binaries"

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.033.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.033.tar.gz"
    sha256 "cc98bbcc33581fbc55b42ae681c6946b70a26f549b3c64466740dfe9a7eac91c"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("DBD::mysql").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
    system "make", "test", "install"
    share.install prefix/"man"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    shell_output("#{bin}/mytop", 1)
  end
end
