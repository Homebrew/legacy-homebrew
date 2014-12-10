require 'formula'

class Calabash < Formula
  homepage 'http://xmlcalabash.com'
  url 'http://xmlcalabash.com/download/calabash-1.0.15-95.zip'
  sha1 'd1cb6f0f26780a504e1f6890a6a3e9261fc28c81'

  head 'https://github.com/ndw/xmlcalabash1.git'

  depends_on 'saxon'

  def install
    libexec.install Dir["*"]
    bin.write_jar_script libexec/'calabash.jar', 'calabash', '-Xmx1024m'
  end

  test do
    # This small XML pipeline (*.xpl) that comes with Calabash
    # is basically its equivalent "Hello World" program.
    system "#{bin}/calabash", "#{libexec}/xpl/pipe.xpl"
  end
end
