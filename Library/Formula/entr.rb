class Entr < Formula
  desc "Run arbitrary commands when files change"
  homepage "http://entrproject.org/"
  url "http://entrproject.org/code/entr-3.2.tar.gz"
  mirror "https://bitbucket.org/eradman/entr/get/entr-3.2.tar.gz"
  sha256 "b1eee00afbeccf03010c1c557436854be6aaf0ef9b72ab8d44b94affdd7d7146"

  head do
    url "https://bitbucket.org/eradman/entr", :using => :hg
    depends_on :hg => :build
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c00d2bdeb3e76cbf3c529160461872aa31468d1c1332b2804546915804135d9c" => :el_capitan
    sha256 "abf6264e4dd04966320b6e2ed371e5c101a3c73e71102f988f5f30ab3aa26b9f" => :yosemite
    sha256 "f2b9660db9526f88691d093b62fcd6c7361c582319fd8609dbd2786f3e1624c0" => :mavericks
    sha256 "896090571a723c7f513e342967a7623bcf3cc0d70af5eabc473f8425c4037ef3" => :mountain_lion
  end

  def install
    ENV["PREFIX"] = prefix
    ENV["MANPREFIX"] = man
    system "./configure"
    system "make"
    system "make", "install"
  end

  test do
    touch testpath/"test.1"
    fork do
      sleep 0.5
      touch testpath/"test.2"
    end
    assert_equal "New File", pipe_output("#{bin}/entr -p -d echo 'New File'", testpath).strip
  end
end
