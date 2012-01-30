require 'formula'

class Mydumper < Formula
  url 'http://launchpadlibrarian.net/77098505/mydumper-0.5.1.tar.gz'
  homepage 'http://www.mydumper.org/'
  md5 'b4df42dfe23f308ab13eb6ecb73a0d21'

  depends_on 'cmake' => :build
  depends_on 'glib'
  depends_on 'pcre'

  def install
    if `which mysql_config`.chomp.empty?
      opoo "`mysql_config` not found"
      puts "This software requires the MySQL client libraries."
      puts "You can install them via Homebrew with one of these:"
      puts "  brew install mysql-connector-c"
      puts "  brew install mysql [--client-only]"
      puts "Without the client libraries, this formula will fail to compile."
    end

    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end

  def test
    system "#{bin}/mydumper --version"
  end
end
