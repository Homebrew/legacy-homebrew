class PerconaToolkit < Formula
  desc "Percona Toolkit for MySQL"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/2.2.14/tarball/percona-toolkit-2.2.14.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/p/percona-toolkit/percona-toolkit_2.2.14.orig.tar.gz"
  sha256 "dd02bedef65536321af6ad3fc6fd8f088e60830267daa613189a14c10ad3a0d0"
  revision 1

  head "lp:percona-toolkit", :using => :bzr

  bottle do
    cellar :any
    revision 1
    sha256 "d371749d14ea3cac95262bbbe0566081b801573b7778039d62778b5273d4ed81" => :el_capitan
    sha256 "ae886b3bf78c6bcb37724e1bc569d76a6f9159701848c050619f96c29f45bb9c" => :yosemite
    sha256 "735e791e9f13df2a8f800dbf95fab147f0de458e9c32337ada5f01420ae05daf" => :mavericks
  end

  depends_on :mysql
  depends_on "openssl"

  conflicts_with "mytop", :because => "both install `perllocal.pod`"

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.033.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.033.tar.gz"
    sha256 "cc98bbcc33581fbc55b42ae681c6946b70a26f549b3c64466740dfe9a7eac91c"
  end

  resource "JSON" do
    url "https://cpan.metacpan.org/authors/id/M/MA/MAKAMAKA/JSON-2.90.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/M/MA/MAKAMAKA/JSON-2.90.tar.gz"
    sha256 "4ddbb3cb985a79f69a34e7c26cde1c81120d03487e87366f9a119f90f7bdfe88"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("JSON").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

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
    system bin/"pt-summary"
  end
end
