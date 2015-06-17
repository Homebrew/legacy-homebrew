class KotlinCompiler < Formula
  desc "Statically typed programming language for the JVM"
  homepage "http://kotlinlang.org/"
  url "https://github.com/JetBrains/kotlin/releases/download/build-0.12.200/kotlin-compiler-0.12.200.zip"
  sha256 "d14a74859698c2a88f004dfb7dd35d35234bc5b99f452694159f2db1ed5a1060"

  bottle do
    cellar :any
    sha256 "1dd707c9f621a243bb2668bed5051ecbf93da2c3090a5f287f609a2aebe343bc" => :yosemite
    sha256 "5441d3359bda051c1dcd9f64a7534e54932a09e99722efb609bbaddf1e274712" => :mavericks
    sha256 "d624292dae9a2ddb7b9f14eaad749d8f1c38465976a64937993ba281baf6eb95" => :mountain_lion
  end

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
