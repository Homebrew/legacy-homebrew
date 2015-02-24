require 'formula'

class Scala < Formula
  homepage 'http://www.scala-lang.org/'
  url 'http://www.scala-lang.org/files/archive/scala-2.11.5.tgz'
  sha1 '10820b7d65727fe8d3d67855ef603c425cf65a4e'

  bottle do
    cellar :any
    sha1 "c674657e9b8382af550f839bcd033fa231e3c3ff" => :yosemite
    sha1 "e0182002187718227972d884057a78784f78d308" => :mavericks
    sha1 "dc90d4a32d6ad90cc3e40070d139c7390f84d77b" => :mountain_lion
  end

  option 'with-docs', 'Also install library documentation'
  option 'with-src', 'Also install sources for IDE support'

  resource 'docs' do
    url 'http://www.scala-lang.org/files/archive/scala-docs-2.11.5.zip'
    sha1 '4a6856a822fbdda7b76674e999a70666d0cdfc3a'
  end

  resource 'src' do
    url 'https://github.com/scala/scala/archive/v2.11.5.tar.gz'
    sha1 '065fbaa0b982256c84df20d444dff03368332b38'
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
