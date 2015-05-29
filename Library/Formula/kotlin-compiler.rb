class KotlinCompiler < Formula
  homepage "http://kotlinlang.org/"
  url "https://github.com/JetBrains/kotlin/releases/download/build-0.12.200/kotlin-compiler-0.12.200.zip"
  sha256 "d14a74859698c2a88f004dfb7dd35d35234bc5b99f452694159f2db1ed5a1060"

  def install
    libexec.install %w[bin lib]
    rm Dir["#{libexec}/bin/*.bat"]
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.kt").write <<-EOS.undent
      fun main(args: Array<String>) {
        println("Hello World!")
      }
    EOS
    system "#{bin}/kotlinc", "test.kt", "-include-runtime", "-d", "test.jar"
    system "#{bin}/kotlinc-js", "test.kt", "-output", "test.js"
    system "#{bin}/kotlinc-jvm", "test.kt", "-include-runtime", "-d", "test.jar"
  end
end
