require 'formula'

class SimpledbAwsLibraries < Formula
  url 'http://aws-libraries.s3.amazonaws.com/perl/AmazonSimpleDB/2009-04-15/AmazonSimpleDB-2009-04-15-perl-library.zip'
  md5 "fcfff6ad8cd867df4dabe8b081bc1b0d"
end

class Simpledb < Formula
  homepage 'http://amazon-simpledb-cli.googlecode.com/'
  url 'http://amazon-simpledb-cli.googlecode.com/svn/trunk', :revision => '23', :using => :svn
  version "r23"
  md5 "11be9d9c7bdd77d881cb6d10ea755c5a"

  def install

    SimpledbAwsLibraries.new.brew { mv 'src', buildpath/'perl-lib' }

    system 'pod2man', 'bin/simpledb', 'simpledb.1'

    system 'mv', 'bin/simpledb', 'simpledb-perl'

    open("simpledb", 'w') { |f|
      f.puts "#!/bin/sh\n"
      f.puts "exec perl -Tw -Mlib=#{prefix}/perl-lib #{prefix}/simpledb-perl \"$@\""
    }

    chmod 0755, 'simpledb'

    prefix.install 'simpledb-perl'
    prefix.install 'perl-lib'
    bin.install 'simpledb'
    man1.install 'simpledb.1'

  end

end
