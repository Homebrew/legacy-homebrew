require 'formula'

class Ivy < Formula
  url 'http://www.apache.org/dist/ant/ivy/2.2.0/apache-ivy-2.2.0-bin.tar.gz'
  homepage 'http://ant.apache.org/ivy/'
  md5 '80d87a17006518a762ceeb88b692cbe6'

  def options
    [['--with-docs', 'Also install ivy documentation']]
  end

  def install
    libexec.install Dir['ivy*']
    if ARGV.include? '--with-docs'
      doc.install Dir['doc/*']
    end

    (bin+'ivy').write <<-EOS.undent
      #!/bin/sh
      #

      cd #{libexec} && java $JAVA_OPTS -jar ivy-#{version}.jar "$@"
    EOS

    (bin+'ivy-fetch').write <<-EOS.undent
    #!/bin/sh
    #

    if [[ $# -lt 2 ]]; then
      cat <<EOM
    Usage: $(basename $0) [ivy options] <organization> <module> <version>

    Resolves a dependency through the ivy cache, downloading any
    required jars.  Examples:
      $(basename $0) org.scala-lang scalap 2.9.1
      $(basename $0) com.google.guava guava r06
    EOM
      exit 1
    fi

    ivy -retrieve ./[artifact]-[revision]-[type].[ext] -dependency "$@"
    EOS

  end

  def test
    # this will fail we won't accept that, make it test the program works!
    system "ivy -version"
  end
end
