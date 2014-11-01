require 'formula'

class Scala < Formula
  homepage 'http://www.scala-lang.org/'
  url 'http://www.scala-lang.org/files/archive/scala-2.11.4.tgz'
  sha1 'a6d319b26ccabe9c609fadebc32e797bf9cb1084'

  bottle do
    cellar :any
    sha1 "3135e56649f81649a90ef0cddb3fa9c9a8208864" => :yosemite
    sha1 "80c33a2bd51cefb57c2e6df0c9956ab49824bb78" => :mavericks
    sha1 "53f58473692d16a1d88b2e515ab04723573232dc" => :mountain_lion
  end

  option 'with-docs', 'Also install library documentation'
  option 'with-src', 'Also install sources for IDE support'

  resource 'docs' do
    url 'http://www.scala-lang.org/files/archive/scala-docs-2.11.4.zip'
    sha1 'de6a5545f13542667d8ff795883fdf192effce2f'
  end

  resource 'src' do
    url 'https://github.com/scala/scala/archive/v2.11.4.tar.gz'
    sha1 '15f9a8f1d3947b5e1ddd3c653968481626caf418'
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
