class PerconaToolkit < Formula
  desc "Percona Toolkit for MySQL"
  homepage "https://www.percona.com/software/percona-toolkit/"
  url "https://www.percona.com/downloads/percona-toolkit/2.2.14/tarball/percona-toolkit-2.2.14.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/p/percona-toolkit/percona-toolkit_2.2.14.orig.tar.gz"
  sha256 "dd02bedef65536321af6ad3fc6fd8f088e60830267daa613189a14c10ad3a0d0"

  head "lp:percona-toolkit", :using => :bzr

  bottle do
    cellar :any
    revision 1
    sha256 "bbfa6abe8440109e4fc32bd7296cfb2518d9c81150023717cff41f8fbab7d584" => :el_capitan
    sha256 "a99afd6d4c648b3666fd23950e84a5d36929c0f8210acd40cc3536f58f7175ab" => :yosemite
    sha256 "0a54b83fa09232f2067af907ae89d48ff8e270bab8b9a6ddbe6b7d9b91ea354a" => :mavericks
  end

  depends_on :mysql
  depends_on "openssl"

  resource "DBD::mysql" do
    url "http://www.cpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.032_01.tar.gz"
    mirror "https://cpan.metacpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.032_01.tar.gz"
    sha256 "76756b24eed46553f9dad22d0682a82b50ca2c8500ea4ede0a414acab48c9e77"
  end

  resource "JSON" do
    url "http://search.cpan.org/CPAN/authors/id/M/MA/MAKAMAKA/JSON-2.90.tar.gz"
    mirror "https://cpan.metacpan.org/authors/id/M/MA/MAKAMAKA/JSON-2.90.tar.gz"
    sha256 "4ddbb3cb985a79f69a34e7c26cde1c81120d03487e87366f9a119f90f7bdfe88"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resource("JSON").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    resource("DBD::mysql").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make", "test", "install"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    system bin/"pt-summary"
  end
end
