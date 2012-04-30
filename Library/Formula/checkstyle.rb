require 'formula'

class Checkstyle < Formula
  homepage 'http://checkstyle.sourceforge.net/'
  url 'http://sourceforge.net/projects/checkstyle/files/checkstyle/5.5/checkstyle-5.5-bin.tar.gz'
  md5 '0dd29971aa26d917d88c229182272056'

  def install
    # wrapper script
    (bin/'checkstyle').write <<-EOS.undent
      #! /usr/bin/env bash -e
      java -jar "#{libexec}/checkstyle-5.5-all.jar" "$@"
    EOS

    libexec.install 'checkstyle-5.5-all.jar', 'sun_checks.xml'
  end

  def test
    mktemp do
      # create test file for `brew test checkstyle`
      (Pathname.pwd/"Test.java").write <<-EOS.undent
        public class Test{
        }
      EOS
      system "#{bin}/checkstyle -c #{libexec}/sun_checks.xml -r Test.java"
    end
  end
end
