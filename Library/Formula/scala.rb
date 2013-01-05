require 'formula'

class ScalaDocs < Formula
  homepage 'http://www.scala-lang.org/'
  url 'http://www.scala-lang.org/downloads/distrib/files/scala-docs-2.10.0.zip'
  sha1 '5bf44bd04b2b37976bde5d4a4c9bb6bcdeb10eb2'

  devel do
    url 'http://www.scala-lang.org/downloads/distrib/files/scala-docs-2.10.0-RC5.zip'
    sha1 '0b600a85a3beb4ec723f3274a21a1b33bb527a87'
  end

end

class ScalaCompletion < Formula
  homepage 'http://www.scala-lang.org/'
  url 'https://raw.github.com/scala/scala-dist/27bc0c25145a83691e3678c7dda602e765e13413/completion.d/2.9.1/scala'
  version '2.9.1'
  sha1 'e2fd99fe31a9fb687a2deaf049265c605692c997'
end

class Scala < Formula
  homepage 'http://www.scala-lang.org/'
  url 'http://www.scala-lang.org/downloads/distrib/files/scala-2.10.0.tgz'
  sha1 '87f605a186aa0e4435b302fb9af575513d29249a'

  devel do
    url 'http://www.scala-lang.org/downloads/distrib/files/scala-2.10.0-RC5.tgz'
    sha1 'd016fd118a82e25ea649753cea122994f946a237'
    version '2.10.0-RC5'
  end

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
