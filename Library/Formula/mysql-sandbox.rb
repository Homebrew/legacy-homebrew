class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "http://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/releases/download/3.1.05/MySQL-Sandbox-3.1.05.tar.gz"
  sha256 "0d0ffbe2c31574bd7e3dd8e10fa01440d34d5cc768243409e75b66971e8f9c75"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "c0355a4d90c4e4a4a6b78bf033d984c63d4836e95cb93844eecf2e439cc2071c" => :el_capitan
    sha256 "e2bc35919240846dd45a6d215f072060380d517c822b95049e683fdca7d08c0e" => :yosemite
    sha256 "2b845b6fe0df229ef598f6743a613773a15d05f3861a117d9102f268a7e6e435" => :mavericks
  end

  def install
    ENV["PERL_LIBDIR"] = libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5/site_perl/"

    system "perl", "Makefile.PL", "PREFIX=#{libexec}"
    system "make", "test", "install"

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/msandbox", 1)
  end
end
