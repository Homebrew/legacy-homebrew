require 'formula'

class ScalaDocs < Formula
  homepage 'http://www.scala-lang.org/'
  url 'http://www.scala-lang.org/downloads/distrib/files/scala-2.9.0.final-devel-docs.tgz'
  head 'http://www.scala-lang.org/downloads/distrib/files/scala-2.9.0.final-devel-docs.tgz'
  version '2.9.0'

  if ARGV.build_head?
    md5 '9856168b833418f8c42ea7e800a3c659'
  else
    md5 '9856168b833418f8c42ea7e800a3c659'
  end
end

class Scala < Formula
  homepage 'http://www.scala-lang.org/'
  url 'http://www.scala-lang.org/downloads/distrib/files/scala-2.9.0.final.tgz'
  head 'http://www.scala-lang.org/downloads/distrib/files/scala-2.9.0.final.tgz'
  version '2.9.0'

  if ARGV.build_head?
    md5 'e9a88a8961c4c1da84ba41d5495a6a43'
  else
    md5 'e9a88a8961c4c1da84ba41d5495a6a43'
  end

  def options
    [['--with-docs', 'Also install library documentation']]
  end

  def install
    rm_f Dir["bin/*.bat"]
    doc.install Dir['doc/*']
    man1.install Dir['man/man1/*']
    libexec.install Dir['*']
    bin.mkpath
    Dir["#{libexec}/bin/*"].each { |f| ln_s f, bin }

    if ARGV.include? '--with-docs'
      ScalaDocs.new.brew { doc.install Dir['*'] }
    end
  end
end
