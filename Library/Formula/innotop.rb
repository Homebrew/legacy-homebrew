class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop"
  url "https://innotop.googlecode.com/files/innotop-1.9.1.tar.gz"
  sha256 "117e5af58a83af79b6cf99877b25b1479197597be5a7d51b245a0ad9c69f4d3d"

  depends_on :mysql

  resource "DBD::mysql" do
    url "http://search.cpan.org/CPAN/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.031.tar.gz"
    mirror "https://cpan.metacpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.031.tar.gz"
    sha256 "ae2ee4339fb13429922d76d37e25ce838f98baa011f691a6bbec8513ddb4cfd2"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resource("DBD::mysql").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make", "install"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end
end
