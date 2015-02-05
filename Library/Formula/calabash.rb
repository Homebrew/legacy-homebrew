class Calabash < Formula
  homepage "http://xmlcalabash.com"
  url "http://xmlcalabash.com/download/calabash-1.0.24-95.zip"
  sha1 "e5443324147891728277880046e5466aef74a8ad"

  depends_on "saxon"

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/"calabash.jar", "calabash", "-Xmx1024m"
  end

  test do
    # This small XML pipeline (*.xpl) that comes with Calabash
    # is basically its equivalent "Hello World" program.
    system "#{bin}/calabash", "#{libexec}/xpl/pipe.xpl"
  end
end
