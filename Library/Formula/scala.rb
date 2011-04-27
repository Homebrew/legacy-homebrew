require 'formula'

class ScalaDocs < Formula
  homepage 'http://www.scala-lang.org/'
  url 'http://www.scala-lang.org/downloads/distrib/files/scala-2.8.1.final-devel-docs.tgz'
  head 'http://www.scala-lang.org/downloads/distrib/files/scala-2.9.0.RC2-devel-docs.tgz'
  version '2.8.1'

  if ARGV.build_head?
    md5 'bac780ac205c6edd78dae90200314484'
  else
    md5 'afd5c7d3073bd735a25cfc4ed61f3543'
  end
end

class Scala < Formula
  homepage 'http://www.scala-lang.org/'
  url 'http://www.scala-lang.org/downloads/distrib/files/scala-2.8.1.final.tgz'
  head 'http://www.scala-lang.org/downloads/distrib/files/scala-2.9.0.RC2.tgz'
  version '2.8.1'

  if ARGV.build_head?
    md5 '396b161129780a371ce7f5da61aa780b'
  else
    md5 '4fa66742341b5c9f6877ce64d409cb92'
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
