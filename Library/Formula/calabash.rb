class Calabash < Formula
  desc "An XProc (XML Pipeline Language) implementation"
  homepage "http://xmlcalabash.com"
  url "https://github.com/ndw/xmlcalabash1/releases/download/1.1.0-95/xmlcalabash-1.1.0-95.zip"
  sha256 "d75a8699ec496fb854761d8e375015732ac51047aad5d7bec57ea3a5349feae7"

  depends_on "saxon"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"xmlcalabash-#{version}.jar", "calabash", "-Xmx1024m"
  end

  test do
    # This small XML pipeline (*.xpl) that comes with Calabash
    # is basically its equivalent "Hello World" program.
    system "#{bin}/calabash", "#{libexec}/xpl/pipe.xpl"
  end
end
