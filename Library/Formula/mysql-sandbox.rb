class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "http://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/releases/download/3.1.05/MySQL-Sandbox-3.1.05.tar.gz"
  sha256 "0d0ffbe2c31574bd7e3dd8e10fa01440d34d5cc768243409e75b66971e8f9c75"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "80088acc66e7ab210d452e78a8d33bfef4edc70616647b2159355a4629282123" => :el_capitan
    sha256 "233476fc5143899aca3763ac7588902e9424c5fff829417ccf7d9200b5e6aea0" => :yosemite
    sha256 "4a9798abe3d89ac7d540ed6ed88b063dd4af82cba417a31375626c00198c5eae" => :mavericks
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
