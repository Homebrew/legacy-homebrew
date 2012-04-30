require 'formula'

class Checkstyle < Formula
  homepage 'http://checkstyle.sourceforge.net/'
  url 'http://sourceforge.net/projects/checkstyle/files/checkstyle/5.5/checkstyle-5.5-bin.tar.gz'
  md5 '0dd29971aa26d917d88c229182272056'

  def install
    # create wrapper script for convenience
    f = File.new "checkstyle", "w"
    f.puts <<-eos
#! /usr/bin/env bash -e
java -jar #{prefix}/checkstyle-5.5-all.jar $@
    eos
    f.close

     # create test file for `brew test checkstyle`
    f = File.new "Test.java", "w"
    f.puts <<-eos
public class Test{
}
    eos
    f.close

    prefix.install 'checkstyle-5.5-all.jar'
    prefix.install 'sun_checks.xml'
    bin.install 'checkstyle'
  end

  def test
    system "checkstyle -c #{prefix}/sun_checks.xml -r #{prefix}/Test.java"
  end
end
