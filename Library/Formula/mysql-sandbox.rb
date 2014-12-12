require "formula"

class MysqlSandbox < Formula
  homepage "http://mysqlsandbox.net"
  url "https://launchpadlibrarian.net/187745286/MySQL-Sandbox-3.0.47.tar.gz"
  sha1 "1759c08c5b7d272b718178bbb7dbc0f52bcb429d"

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
