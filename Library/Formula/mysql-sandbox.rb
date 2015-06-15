class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "http://mysqlsandbox.net"
  url "https://launchpad.net/mysql-sandbox/mysql-sandbox-3/mysql-sandbox-3/+download/MySQL-Sandbox-3.0.50.tar.gz"
  sha256 "c709c4dec711ab37265c5c596330ad3af01866f418e8158cdf949efcdcab96d8"

  bottle do
    sha256 "1ad86e367e36e62fe32b15fc93129f0f8ef5ab43f0e2ab171df22361fc3b48ff" => :yosemite
    sha256 "3bd2fb88ca6d0aa370396962233e3a925c5f67cd205a1a46279a6a7cdb2c8f87" => :mavericks
    sha256 "08da8aa5ab71e34f9f87838ff3b5f17c53a021683c569df000d27940890b7d7b" => :mountain_lion
  end

  def install
    ENV.prepend_create_path "PERL5LIB", "#{HOMEBREW_PREFIX}/lib/perl5/site_perl"

    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make", "test", "install"

    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end
end
