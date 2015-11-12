class Mytop < Formula
  desc "Top-like query monitor for MySQL"
  homepage "http://www.mysqlfanboy.com/mytop-3/"
  url "http://www.mysqlfanboy.com/mytop-3/mytop-1.9.1.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/m/mytop/mytop_1.9.1.orig.tar.gz"
  sha256 "179d79459d0013ab9cea2040a41c49a79822162d6e64a7a85f84cdc44828145e"

  bottle do
    sha256 "4793de7b30f9e23febec3d1e4c324667ee456a9951b9e4e48b6fa2224e1abc3e" => :yosemite
    sha256 "ad477677188f97f67000057d3b8de142175659c38e72bcad59ce0dd8e984ba15" => :mavericks
    sha256 "a2ea7a6dbc5526a2227e21aa3ca7a28b79272762c4d77d5245445ca5629c27c9" => :mountain_lion
  end

  depends_on :mysql
  depends_on "openssl"

  resource "DBD::mysql" do
    url "http://search.cpan.org/CPAN/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.027.tar.gz"
    mirror "http://search.mcpan.org/CPAN/authors/id/C/CA/CAPTTOFU/DBD-mysql-4.027.tar.gz"
    sha256 "2e00f1eb5822aa097b310203ff611dd635f9d000db9df7ce1e8b0493c082be41"
  end

  conflicts_with "mariadb", :because => "both install `mytop` binaries"

  def install
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    resource("DBD::mysql").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make", "test", "install"
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    shell_output("#{bin}/mytop", 1)
  end
end
