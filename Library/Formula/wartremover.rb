class Wartremover < Formula
  desc "Flexible Scala code linting tool"
  homepage "https://github.com/puffnfresh/wartremover"
  url "https://github.com/puffnfresh/wartremover/archive/v0.13.tar.gz"
  sha256 "65d2f9907662bc2cc892801055713dd80a7fc25ade5091cb534bfc51eaae626b"

  head "https://github.com/puffnfresh/wartremover.git"

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
