require 'formula'

class Scala < Formula
  homepage 'http://www.scala-lang.org/'
  url 'http://www.scala-lang.org/files/archive/scala-2.11.6.tgz'
  sha1 'f30ff4104b0fed5c4beca2b599b8f67e66b7f4e6'

  bottle do
    cellar :any
    sha1 "4f98ce5d49a4e4dffbb00becd7f7a9e1733ec04e" => :yosemite
    sha1 "3d99131300d5fc87b6867eee16c73e7e68667c52" => :mavericks
    sha1 "15310848fa89566423225e6547505c2aa246d249" => :mountain_lion
  end

  option 'with-docs', 'Also install library documentation'
  option 'with-src', 'Also install sources for IDE support'

  resource 'docs' do
    url 'http://www.scala-lang.org/files/archive/scala-docs-2.11.6.zip'
    sha1 'b646de99bb38de779bdc65ce0e48c727da4778f7'
  end

  resource 'src' do
    url 'https://github.com/scala/scala/archive/v2.11.6.tar.gz'
    sha1 '96911a7f5faf6768744322be59e6eb7df4a3af53'
  end

  resource 'completion' do
    url 'https://raw.githubusercontent.com/scala/scala-dist/v2.11.4/bash-completion/src/main/resources/completion.d/2.9.1/scala'
    sha1 'e2fd99fe31a9fb687a2deaf049265c605692c997'
  end

  def install
    rm_f Dir["bin/*.bat"]
    doc.install Dir['doc/*']
    share.install "man"
    libexec.install "bin", "lib"
    bin.install_symlink Dir["#{libexec}/bin/*"]
    bash_completion.install resource('completion')
    doc.install resource('docs') if build.with? 'docs'
    libexec.install resource('src').files('src') if build.with? 'src'

    # Set up an IntelliJ compatible symlink farm in 'idea'
    idea = prefix/'idea'
    idea.install_symlink libexec/'src', libexec/'lib'
    idea.install_symlink doc => 'doc'
  end

  def caveats; <<-EOS.undent
    To use with IntelliJ, set the Scala home to:
      #{opt_prefix}/idea
    EOS
  end

  test do
    file = testpath/'hello.scala'
    file.write <<-EOS.undent
      object Computer {
        def main(args: Array[String]) {
          println(2 + 2)
        }
      }
    EOS
    assert_equal "4", shell_output("#{bin}/scala #{file}").strip
  end
end
