require 'formula'

class ScalaDocs < Formula
  homepage 'http://www.scala-lang.org/'
  url 'http://www.scala-lang.org/downloads/distrib/files/scala-2.9.1-1-devel-docs.tgz'
  version '2.9.1-1'
  md5 '6bfdd990c379c1b2c87335c89f6c444c'
end

class ScalaCompletion < Formula
  homepage 'http://www.scala-lang.org/'
  url 'https://raw.github.com/scala/scala-dist/27bc0c25145a8/completion.d/2.9.1/scala'
  version '2.9.1'
  md5 '40cb02604b718fd0977a12d932b9e693'
end

class Scala < Formula
  homepage 'http://www.scala-lang.org/'
  url 'http://www.scala-lang.org/downloads/distrib/files/scala-2.9.1-1.tgz'
  version '2.9.1-1'
  md5 'bde2427b3f56e9c5ccb86a4376ac0d93'

  def options
    [['--with-docs', 'Also install library documentation']]
  end

  def caveats; <<-EOS.undent
    Bash completion has been installed to:
      #{etc}/bash_completion.d
    EOS
  end

  def install
    rm_f Dir["bin/*.bat"]
    doc.install Dir['doc/*']
    man1.install Dir['man/man1/*']
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
    ScalaCompletion.new.brew { (prefix+'etc/bash_completion.d').install 'scala' }

    if ARGV.include? '--with-docs'
      ScalaDocs.new.brew { doc.install Dir['*'] }
    end
  end
end
