class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "http://mysqlsandbox.net"
  url "https://github.com/datacharmer/mysql-sandbox/archive/3.1.00.tar.gz"
  sha256 "50934d23ec40b209cc08c19a7b38ea70e1f15f00845f91da0581e7e1cba4cf29"
  head "https://github.com/datacharmer/mysql-sandbox.git"

  bottle do
    sha256 "1ad86e367e36e62fe32b15fc93129f0f8ef5ab43f0e2ab171df22361fc3b48ff" => :yosemite
    sha256 "3bd2fb88ca6d0aa370396962233e3a925c5f67cd205a1a46279a6a7cdb2c8f87" => :mavericks
    sha256 "08da8aa5ab71e34f9f87838ff3b5f17c53a021683c569df000d27940890b7d7b" => :mountain_lion
  end

  def install
    # Theoretically, we could reinsert a patch here submitted upstream previously
    # but the check for PERL_LIB remains in place and incompatible with Homebrew.
    # Using an env and scripting is a solution less likely to break over time.
    # Both variables need to be set. One is compile-time, the other run-time.
    ENV["PERL_LIBDIR"] = libexec/"lib/perl5"
    ENV.prepend_create_path "PERL5LIB", libexec+"lib/perl5"

    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make", "test", "install"

    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end
end
