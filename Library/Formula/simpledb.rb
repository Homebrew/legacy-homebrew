# [apl 8.may.2012]
# This formula is to install a third-party tool that allows for command
# line access to the Amazon Web Services Simple DB service.  The perl
# script requires additional third-party perl libraries to function. In
# order for the install process to be self-contained, those libraries
# are downloaded and then unpacked into the same target directory as
# the 'simpledb' script.  A proxy-script is generated to launch the
# 'simpledb' script in such a way that it is able to reference the
# third party perl libraries.

require 'formula'

class Simpledb < Formula
  homepage 'http://amazon-simpledb-cli.googlecode.com/'
  url 'http://amazon-simpledb-cli.googlecode.com/svn/trunk', :revision => '23', :using => :svn
  version "r23"
  md5 "11be9d9c7bdd77d881cb6d10ea755c5a"

  def install

    system "curl 'http://aws-libraries.s3.amazonaws.com/perl/AmazonSimpleDB/2009-04-15/AmazonSimpleDB-2009-04-15-perl-library.zip' > AmazonSimpleDB-2009-04-15-perl-library.zip"
    system "unzip 'AmazonSimpleDB-2009-04-15-perl-library.zip'"
    system "mv AmazonSimpleDB-2009-04-15-perl-library/src perl-lib"
    system "mv bin/simpledb simpledb-perl"

    open("simpledb", 'w') { |f|
      f.puts "#!/bin/sh\n"
      f.puts "exec perl -Tw -Mlib=#{prefix}/perl-lib #{prefix}/simpledb-perl \"$@\""
    }

    chmod 0755, 'simpledb'

    prefix.install 'simpledb-perl'
    prefix.install 'perl-lib'
    bin.install 'simpledb'

    ohai 'To get information about how to use simpledb, execute \'/usr/local/bin/simpledb --help\''

  end

end
