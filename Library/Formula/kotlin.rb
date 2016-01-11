class Kotlin < Formula
  desc "Statically typed programming language for the JVM"
  homepage "https://kotlinlang.org/"
  url "https://github.com/JetBrains/kotlin/releases/download/build-1.0.0-beta-4584/kotlin-compiler-1.0.0-beta-4584.zip"
  version "1.0.0-beta-4584"
  sha256 "191698784f4a1f769df14757bad40243293aa6bc3d8e906bfa0c80c3db0a1d2c"

  bottle :unneeded

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
