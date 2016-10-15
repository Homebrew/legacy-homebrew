class KotlinCompiler < Formula
  homepage "http://kotlinlang.org/"
  url "https://github.com/JetBrains/kotlin/releases/download/M11.1-bootstrap/kotlin-compiler-0.11.91.1.zip"
  sha256 "5a68aa0f42d1e14f28fdcbf317d873fdbac1ef736934f7877fa26dac64377f64"

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
