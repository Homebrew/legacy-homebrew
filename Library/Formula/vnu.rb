require "formula"

class Vnu < Formula
  homepage "https://validator.github.io/validator/"
  url "https://github.com/validator/validator/releases/download/20141006/vnu-20141013.jar.zip"
  sha1 "48bfcb41e6faf9130c5f1698497e0ec15ddfd657"
  version "20141013"

  def install
    libexec.install "vnu.jar"
    bin.write_jar_script libexec/"vnu.jar", "vnu"
  end

  test do
    path = testpath/"index.html"
    path.write <<-EOS
      <!DOCTYPE html>
      <html>
      <head>
        <title>hi</title>
      </head>
      <body>
      </body>
      </html>
    EOS

    system bin/"vnu", path
  end
end
