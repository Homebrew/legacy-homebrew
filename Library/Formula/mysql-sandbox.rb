require "formula"

class MysqlSandbox < Formula
  homepage "http://mysqlsandbox.net"
  url "https://launchpadlibrarian.net/187745286/MySQL-Sandbox-3.0.47.tar.gz"
  sha1 "1759c08c5b7d272b718178bbb7dbc0f52bcb429d"

  def install
    ENV.prepend_create_path "PERL5LIB", "#{HOMEBREW_PREFIX}/lib/perl5/site_perl"

    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make", "test", "install"

    bin.env_script_all_files(libexec+"bin", :PERL5LIB => ENV["PERL5LIB"])
  end
end
