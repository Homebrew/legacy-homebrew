require 'formula'

class ScalaDocs < Formula
  homepage 'http://www.scala-lang.org/'
  url 'http://www.scala-lang.org/downloads/distrib/files/scala-docs-2.9.2.zip'
  md5 '48d9102789bf696d3d8621fb24ed47da'
end

class ScalaCompletion < Formula
  homepage 'http://www.scala-lang.org/'
  url 'https://raw.github.com/scala/scala-dist/27bc0c25145a83691e3678c7dda602e765e13413/completion.d/2.9.1/scala'
  version '2.9.1'
  md5 '40cb02604b718fd0977a12d932b9e693'
end

class Scala < Formula
  homepage 'http://www.scala-lang.org/'
  url 'http://www.scala-lang.org/downloads/distrib/files/scala-2.9.2.tgz'
  md5 'bc1f68ce3f989347231f2e23784deee9'

  option 'with-docs', 'Also install library documentation'

  def install
    rm_f Dir["bin/*.bat"]
    doc.install Dir['doc/*']
    man1.install Dir['man/man1/*']
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]
    ScalaCompletion.new.brew { (prefix/'etc/bash_completion.d').install 'scala' }
    ScalaDocs.new.brew { doc.install Dir['*'] } if build.include? 'with-docs'
  end
end
