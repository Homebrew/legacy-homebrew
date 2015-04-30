class KotlinCompiler < Formula
  homepage "http://kotlinlang.org/"
  url "https://github.com/JetBrains/kotlin/releases/download/M11.1-bootstrap/kotlin-compiler-0.11.91.1.zip"
  sha256 "5a68aa0f42d1e14f28fdcbf317d873fdbac1ef736934f7877fa26dac64377f64"


  def install
    libexec.install %w[bin lib]
    bin.install_symlink "#{libexec}/bin/kotlinc"
    bin.install_symlink "#{libexec}/bin/kotlinc-js"
    bin.install_symlink "#{libexec}/bin/kotlinc-jvm"
  end

  test do
    system "#{bin}/kotlinc", "-version"
  end
end
