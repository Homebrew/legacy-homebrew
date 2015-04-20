class Scalariform < Formula
  homepage "https://github.com/daniel-trinh/scalariform"
  url "https://github.com/daniel-trinh/scalariform/releases/download/0.1.6/scalariform.jar"
  sha256 "346276c5f3a25a44d64ed38f43739813933487299a651f7c64db748427641c54"

  def install
    libexec.install "scalariform.jar"
    bin.write_jar_script libexec/"scalariform.jar", "scalariform"
  end

  test do
    before_data = <<-EOS.undent
      def foo() {
      println("Hello World")
      }
    EOS

    after_data = <<-EOS.undent
      def foo() {
         println("Hello World")
      }
    EOS

    (testpath/"foo.scala").write before_data
    system bin/"scalariform", "-indentSpaces=3", testpath/"foo.scala"
    assert_equal after_data, (testpath/"foo.scala").read
  end
end
