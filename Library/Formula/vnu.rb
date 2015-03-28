class Vnu < Formula
  homepage "https://validator.github.io/validator/"
  url "https://github.com/validator/validator/releases/download/15.3.28/vnu.jar_15.3.28.zip"
  sha256 "5b7d17fca4900253d30d0b367afa1b7afc3b8f09f3cfa4e4e656e679b21d7841"
  version "20150328"

  def install
    libexec.install "vnu.jar"
    bin.write_jar_script libexec/"vnu.jar", "vnu"
  end

  test do
    (testpath/"index.html").write <<-EOS.undent
      <!DOCTYPE html>
      <html>
      <head>
        <title>hi</title>
      </head>
      <body>
      </body>
      </html>
    EOS
    system bin/"vnu", testpath/"index.html"
  end
end
