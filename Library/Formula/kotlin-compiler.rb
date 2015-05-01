class KotlinCompiler < Formula
  homepage "http://kotlinlang.org/"
  url "https://github.com/JetBrains/kotlin/releases/download/build-0.10.195/kotlin-compiler-0.10.195.zip"
  sha1 "f37b8ed7dd6e71ad367b1d2356d12edbeb598479"

  depends_on :java => "1.6+"

  def install
    libexec.install %w[bin lib]
    bin.install_symlink [libexec/"bin/kotlinc", libexec/"bin/kotlinc-js", libexec/"bin/kotlinc-jvm"]
  end

  test do
    script_path = testpath/"test.kts"
    script_path.write "println(\"Hello Kotlin\")"
    assert_equal "Hello Kotlin", shell_output("#{bin}/kotlinc -script #{script_path}").strip
  end
end
