class MysqlSandbox < Formula
  desc "Install one or more MySQL servers"
  homepage "http://mysqlsandbox.net"
  url "https://launchpad.net/mysql-sandbox/mysql-sandbox-3/mysql-sandbox-3/+download/MySQL-Sandbox-3.0.50.tar.gz"
  sha256 "c709c4dec711ab37265c5c596330ad3af01866f418e8158cdf949efcdcab96d8"

  bottle do
    sha1 "897c13c030850fae4ea21698c38f214f1d4e1609" => :yosemite
    sha1 "2ce186a294c8e76d673d65dadd5a09a978f62f56" => :mavericks
    sha1 "027b0af0c13bc153323fd46f9492635c265bd4a3" => :mountain_lion
  end

  def install
    ENV.prepend_create_path "PERL5LIB", "#{HOMEBREW_PREFIX}/lib/perl5/site_perl"

    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make", "test", "install"

    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end
end
