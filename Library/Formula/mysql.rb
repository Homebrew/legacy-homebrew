require 'brewkit'

class Mysql <Formula
  @url='http://mysql.llarian.net/Downloads/MySQL-5.1/mysql-5.1.37.zip'
  @homepage='http://dev.mysql.com/doc/refman/5.1/en/'
  @md5='7564d7759a8077b3a0e6190955422287'

  def deps
    'readline'
  end

  def options
    [
      ['--with-tests', "Keep tests when installing."],
      ['--with-bench', "Keep benchmark app when installing."],
      ['--client-only', "Only install client tools, not the server."],
    ]
  end

  def install
    ENV['CXXFLAGS'] = ENV['CXXFLAGS'].gsub "-fomit-frame-pointer", ""
    ENV['CXXFLAGS'] += " -fno-omit-frame-pointer -felide-constructors"

    configure_args = [
      "--without-bench",
      "--without-docs",
      "--without-debug",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--with-plugins=innobase,myisam",
      "--with-extra-charsets=complex",
      "--with-plugins=innobase,myisam",
      "--with-ssl",
      "--enable-assembler",
      "--enable-thread-safe-client",
      "--enable-local-infile",
      "--enable-shared"]

    if ARGV.include? '--client-only'
      configure_args.push("--without-server")
    end

    system "./configure", *configure_args
    system "make install"

    # Why does sql-bench still get built w/ above options?
    (prefix+'sql-bench').rmtree unless ARGV.include? '--with-bench'

    # save 66MB!
    (prefix+'mysql-test').rmtree unless ARGV.include? '--with-tests'
  end
end
