class Frege < Formula
  desc "Non-strict, functional programming language in the spirit of Haskell"
  homepage "https://github.com/Frege/frege/"
  url "https://github.com/Frege/frege/releases/download/3.22.324/frege3.22.524-gcc99d7e.jar"
  version "3.22.524-gcc99d7e"
  sha256 "8508f5b1f03beb69311a059e9a1684dfd0212ed1501fa96626f1e0b69363338a"

  bottle :unneeded

  depends_on :java => "1.7+"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"frege#{version}.jar", "fregec", "-Xss1m"
  end

  test do
    (testpath/"test.fr").write <<-EOS
      module Hello where

      greeting friend = "Hello, " ++ friend ++ "!"

      main args = do
          println (greeting "World")
    EOS
    system bin/"fregec", "-d", testpath, "test.fr"
    system "java", "-Xss1m", "-cp", "#{testpath}:#{libexec}/frege#{version}.jar", "Hello"
  end
end
