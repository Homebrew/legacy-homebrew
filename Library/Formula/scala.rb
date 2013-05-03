require 'formula'

class ScalaDocs < Formula
  homepage 'http://www.scala-lang.org/'
  url 'http://www.scala-lang.org/downloads/distrib/files/scala-docs-2.10.1.zip'
  sha1 '7ff73776f7af9d6b2d5081a3a6ffa2a442640a59'
end

class ScalaCompletion < Formula
  homepage 'http://www.scala-lang.org/'
  url 'https://raw.github.com/scala/scala-dist/27bc0c25145a83691e3678c7dda602e765e13413/completion.d/2.9.1/scala'
  version '2.9.1'
  sha1 'e2fd99fe31a9fb687a2deaf049265c605692c997'
end

class Scala < Formula
  homepage 'http://www.scala-lang.org/'
  url 'http://www.scala-lang.org/downloads/distrib/files/scala-2.10.1.tgz'
  sha1 '589cc2ba688510f2ec169837b44be5db9fd538b6'

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
