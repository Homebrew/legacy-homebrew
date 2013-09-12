require 'formula'

class ScalaDocs < Formula
  homepage 'http://www.scala-lang.org/'
  url 'http://www.scala-lang.org/files/archive/scala-docs-2.10.2.zip'
  sha1 '96107dafb44af30d24c07fc29feddbf470377cdd'

  devel do
    url 'http://www.scala-lang.org/files/archive/scala-docs-2.11.0-M4.zip'
    sha1 '24be02960fda935ab8d5a67b902147af3c95ced4'
  end
end

class Scala < Formula
  homepage 'http://www.scala-lang.org/'
  url 'http://www.scala-lang.org/files/archive/scala-2.10.2.tgz'
  sha1 '86b4e38703d511ccf045e261a0e04f6e59e3c926'

  devel do
    url 'http://www.scala-lang.org/files/archive/scala-2.11.0-M4.tgz'
    sha1 '43e0983cebe75154e41a6b35a5b82bdc5bdbbaa2'
  end

  option 'with-docs', 'Also install library documentation'

  resource 'completion' do
    url 'https://raw.github.com/scala/scala-dist/27bc0c25145a83691e3678c7dda602e765e13413/completion.d/2.9.1/scala'
    sha1 'e2fd99fe31a9fb687a2deaf049265c605692c997'
  end

  def install
    rm_f Dir["bin/*.bat"]
    doc.install Dir['doc/*']
    man1.install Dir['man/man1/*']
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/*"]

    bash_completion.install resource('completion')

    ScalaDocs.new.brew do
      branch = build.stable? ? 'scala-2.10' : 'scala-2.11'
      (share/'doc'/branch).install Dir['*']
    end if build.include? 'with-docs'

    # Set up an IntelliJ compatible symlink farm in 'idea'
    idea = prefix/'idea'
    idea.install_symlink libexec/'src', libexec/'lib'
    (idea/'doc/scala-devel-docs').install_symlink doc => 'api'
  end

  def caveats; <<-EOS.undent
    To use with IntelliJ, set the Scala home to:
      #{opt_prefix}/idea
    EOS
  end
end
