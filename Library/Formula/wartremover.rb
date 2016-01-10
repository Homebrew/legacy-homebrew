class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/puffnfresh/wartremover"
  url "https://github.com/puffnfresh/wartremover/archive/v0.13.tar.gz"
  sha256 "65d2f9907662bc2cc892801055713dd80a7fc25ade5091cb534bfc51eaae626b"

  head "https://github.com/puffnfresh/wartremover.git"

  bottle do
    cellar :any
    sha256 "7cf8e78114d8212a56e71cf62b415151e0458141bef644a4a5f8e75417cc7f8b" => :yosemite
    sha256 "a5c0eb64c5d8165c918772f3462eada415ad90545f77eb6d8aa8d636ba73ed32" => :mavericks
    sha256 "4727d2f98bbe8c3b4e60a99cb97af633a1b33a8a1e42b8caade98ebd1d7131d0" => :mountain_lion
  end

  depends_on "sbt" => :build

  def install
    system "sbt", "core/assembly"
    libexec.install Dir["core/target/scala-*/wartremover-assembly-*.jar"]
    bin.write_jar_script Dir[libexec/"wartremover-assembly-*.jar"][0], "wartremover"
  end

  test do
    test_data = <<-EOS.undent
      object Foo {
        def foo() {
          var msg = "Hello World"
          println(msg)
        }
      }
    EOS

    (testpath/"foo.scala").write test_data
    cmd = "#{bin}/wartremover -traverser org.brianmckenna.wartremover.warts.Unsafe #{testpath}/foo.scala 2>&1"
    assert_match /var is disabled/, shell_output(cmd, 1)
  end
end
