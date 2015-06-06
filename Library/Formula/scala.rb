class Scala < Formula
  desc "Scala programming language"
  homepage "http://www.scala-lang.org/"

  bottle do
    cellar :any
    sha1 "4f98ce5d49a4e4dffbb00becd7f7a9e1733ec04e" => :yosemite
    sha1 "3d99131300d5fc87b6867eee16c73e7e68667c52" => :mavericks
    sha1 "15310848fa89566423225e6547505c2aa246d249" => :mountain_lion
  end

  option "with-docs", "Also install library documentation"
  option "with-src", "Also install sources for IDE support"

  stable do
    url "http://www.scala-lang.org/files/archive/scala-2.11.6.tgz"
    sha256 "41ba45e4600404634217a66d6b2c960459d3a67e0344a7c3d9642d0eaa446583"

    resource "docs" do
      url "http://www.scala-lang.org/files/archive/scala-docs-2.11.6.zip"
      sha256 "aa7fb121cc0e50d32cd85b162b684d30be383aab42ec9b59589e389af8b62254"
    end

    resource "src" do
      url "https://github.com/scala/scala/archive/v2.11.6.tar.gz"
      sha256 "0ccf26576dacd2792af09a146a43a15b25201d47891f83c3dc8f9a04c79e88b1"
    end
  end

  devel do
    url "http://www.scala-lang.org/files/archive/scala-2.12.0-M1.tgz"
    sha256 "e48971939fa0f82ff3190ecafd22ad98d9d00eb4aef09cd2197265dc44f72eee"
    version "2.12.0-M1"

    resource "docs" do
      url "http://www.scala-lang.org/files/archive/scala-docs-2.12.0-M1.zip"
      sha256 "36683ec16e30b69e3abf424c8cff1d49ebfd5f07b4cd3a015ced767a1ca81221"
      version "2.12.0-M1"
    end

    resource "src" do
      url "https://github.com/scala/scala/archive/v2.12.0-M1.tar.gz"
      sha256 "0c129529b8dbafa89782c997904705dc59d5b9abf01f97218f86f1c602fca339"
      version "2.12.0-M1"
    end
  end

  resource "completion" do
    url "https://raw.githubusercontent.com/scala/scala-dist/v2.11.4/bash-completion/src/main/resources/completion.d/2.9.1/scala"
    sha256 "95aeba51165ce2c0e36e9bf006f2904a90031470ab8d10b456e7611413d7d3fd"
  end

  def install
    rm_f Dir["bin/*.bat"]
    doc.install Dir["doc/*"]
    share.install "man"
    libexec.install "bin", "lib"
    bin.install_symlink Dir["#{libexec}/bin/*"]
    bash_completion.install resource("completion")
    doc.install resource("docs") if build.with? "docs"
    libexec.install resource("src").files("src") if build.with? "src"

    # Set up an IntelliJ compatible symlink farm in 'idea'
    idea = prefix/"idea"
    idea.install_symlink libexec/"src", libexec/"lib"
    idea.install_symlink doc => "doc"
  end

  def caveats; <<-EOS.undent
    To use with IntelliJ, set the Scala home to:
      #{opt_prefix}/idea
    EOS
  end

  test do
    file = testpath/"hello.scala"
    file.write <<-EOS.undent
      object Computer {
        def main(args: Array[String]) {
          println(s"${2 + 2}")
        }
      }
    EOS
    assert_equal "4", shell_output("#{bin}/scala #{file}").strip
  end
end
