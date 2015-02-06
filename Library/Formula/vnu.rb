class Vnu < Formula
  homepage "https://validator.github.io/validator/"
  url "https://github.com/validator/validator/releases/download/20150207/vnu-20150207.jar.zip"
  sha1 "30f840cb36185b27e4941eeff43929b6bbe05d0c"
  version "20150207"

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
