class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "http://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.1.00.tar.gz"
  sha256 "50934d23ec40b209cc08c19a7b38ea70e1f15f00845f91da0581e7e1cba4cf29"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fda093673b17f173d861f451f47590abeb140d0add10999e324a6b320722b192" => :el_capitan
    sha256 "f9676cd687585bef7b34939884e592411581ac0835a601da04188681aa34d031" => :yosemite
    sha256 "615972d1ddbdff6654f7ba4cd140b0787342604a0313b96dd9817e0b834e5477" => :mavericks
  end

  def install
    # Both variables need to be set. One is compile-time, the other run-time.
    ENV["PERL_LIBDIR"] = libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make", "test", "install"

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end
end
