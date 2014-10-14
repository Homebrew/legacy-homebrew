require 'formula'

class Scala < Formula
  homepage 'http://www.scala-lang.org/'
  url 'http://www.scala-lang.org/files/archive/scala-2.11.2.tgz'
  sha1 '904e9ee3bb96e8350b1e0f2502a704f836c0cdf1'

  bottle do
    cellar :any
    sha1 "503e0df68c8b5033217483d2fb9e81cb8bc7a50e" => :mavericks
    sha1 "206c79f192f48025f4c22cdf8dd420a771c0ec2a" => :mountain_lion
    sha1 "300bcb87c513daf7c155b14958b4f6c3dc977ac3" => :lion
  end

  option 'with-docs', 'Also install library documentation'
  option 'with-src', 'Also install sources for IDE support'

  resource 'docs' do
    url 'http://www.scala-lang.org/files/archive/scala-docs-2.11.2.zip'
    sha1 '2add2130989c3434b8f6ef30f05ed3dd98ab156a'
  end

  resource 'src' do
    url 'https://github.com/scala/scala/archive/v2.11.2.tar.gz'
    sha1 '52654124565a1706e9e6d0ad7b0969d319628847'
  end

  resource 'completion' do
    url 'https://raw.githubusercontent.com/scala/scala-dist/v2.11.2/bash-completion/src/main/resources/completion.d/2.9.1/scala'
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
    (idea/'doc/scala-devel-docs').install_symlink doc => 'api'
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
