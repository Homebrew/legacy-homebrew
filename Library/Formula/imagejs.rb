class Imagejs < Formula
  homepage "http://jklmnn.de/imagejs/"
  url "https://github.com/jklmnn/imagejs/archive/0.7.1.tar.gz"
  sha1 "4c3e1c2134194cced5924c9cc577d36165548575"
  head "https://github.com/jklmnn/imagejs.git"

  def install
    system "make"
    bin.install "imagejs"
  end

  test do
    (testpath/"test.js").write "alert('Hello World!')"
    system "#{bin}/imagejs", "bmp", "test.js", "-l"
  end
end
