class KotlinCompiler < Formula
  desc "Statically typed programming language for the JVM"
  homepage "http://kotlinlang.org/"
  url "https://github.com/JetBrains/kotlin/releases/download/build-0.13.1513/kotlin-compiler-0.13.1513.zip"
  sha256 "ac93ad3360f38ba2692a7f8bc7b7c74e8ca4cdb03e6e71377c51cd44bf842698"

  bottle do
    cellar :any
    sha256 "c4dd4a056800031c1a40ab9cf8245512f7058ab498662d59de9cb06d4dd76617" => :yosemite
    sha256 "3afbc461229e3d9263cacc3fe616230aa34853dd3fea8a4a5ee102254cd711ba" => :mavericks
    sha256 "b21f3ef222bd11e995e47439d2b8ae42e7142fbc716feef0e33eb4b7192eda40" => :mountain_lion
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
