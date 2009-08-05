# Builds MySQL 5.1, but only the client libraries and tools.
# Does not install the mysqld server.
require 'brewkit'

class Mysql <Formula
  @url='http://mysql.llarian.net/Downloads/MySQL-5.1/mysql-5.1.37.zip'
  @homepage='http://dev.mysql.com/doc/refman/5.1/en/'
  @md5='7564d7759a8077b3a0e6190955422287'

  def deps
    # --without-readline means use system's readline
    LibraryDep.new 'readline'
  end

  def install
    ENV['CXXFLAGS'] = ENV['CXXFLAGS'].gsub "-fomit-frame-pointer", ""
    ENV['CXXFLAGS'] += " -fno-omit-frame-pointer -felide-constructors"

    # What about these options?
    # --with-mysqld-ldflags=-all-static
    # --enable-assembler
    # --with-atomic-ops

    system "./configure", "--without-readline", 
                          "--without-server",
                          "--without-bench",
                          "--without-docs",
                          "--without-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-extra-charsets=complex",
                          "--enable-thread-safe-client",
                          "--enable-local-infile",
                          "--enable-shared"
    system "make install"
    
    # save 66MB :P
    (prefix+'mysql-test').rmtree unless ARGV.include? '--with-tests'
  end
  
  def caveats
    <<-EOS
Currently we don't build the server (mysqld), however this should be the 
default. So please amend this formula, and add a --client-tools-only option
for installation for its existing state. Thanks.
    EOS
  end
end
