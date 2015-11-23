class Innotop < Formula
  desc "Top clone for MySQL"
  homepage "https://github.com/innotop/innotop/"
  url "https://innotop.googlecode.com/files/innotop-1.9.1.tar.gz"
  sha256 "117e5af58a83af79b6cf99877b25b1479197597be5a7d51b245a0ad9c69f4d3d"
  revision 1

  head "https://github.com/innotop/innotop.git"

  bottle do
    cellar :any
    sha256 "e4a6a4bf7f7d79d7075d4f6039d503372910be9f871e76fdeb13e29fe6212143" => :el_capitan
    sha256 "a5ab3512b7c0959447f009495e95580086e3489407b6fc1cec7f67d3548314c8" => :yosemite
    sha256 "36698acfd859e30239379ae9d7b99276903d03f05598eb276a35c0f1d3f10812" => :mavericks
  end

  depends_on :mysql
  depends_on "openssl"

  conflicts_with "mytop", :because => "both install `perllocal.pod`"

  resource "DBD::mysql" do
    url "https://cpan.metacpan.org/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.033.tar.gz"
    mirror "http://search.cpan.org/CPAN/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.033.tar.gz"
    sha256 "cc98bbcc33581fbc55b42ae681c6946b70a26f549b3c64466740dfe9a7eac91c"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("DBD::mysql").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{prefix}"
    system "make", "install"
    share.install prefix/"man"
    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    # Calling commands throws up interactive GUI, which is a pain.
    assert_match version.to_s, shell_output("#{bin}/innotop --version")
  end
end
