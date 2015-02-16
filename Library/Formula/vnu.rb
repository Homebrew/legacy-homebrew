class Vnu < Formula
  homepage "https://validator.github.io/validator/"
  url "https://github.com/validator/validator/releases/download/20150216/vnu-20150216.jar.zip"
  sha1 "d4189c5f2687483f8edd4d5b1bb57b3c612cd611"
  version "20150216"

  def install
    libexec.install "vnu.jar"
    bin.write_jar_script libexec/"vnu.jar", "vnu"
  end

  test do
    path = testpath/"index.html"
    path.write <<-EOS.undent
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
