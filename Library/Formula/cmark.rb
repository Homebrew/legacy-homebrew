class Cmark < Formula
  homepage "http://commonmark.org/"
  url "https://github.com/jgm/cmark/archive/0.17.tar.gz"
  sha1 "a0bce3d321822ca96f312e9210fc8cd149a8f527"
  head "https://github.com/jgm/cmark.git"

  depends_on "cmake" => :build
  depends_on "re2c" => :build

  def install
    ENV.deparallelize
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.md").write <<-EOS.undent
      # Title

      text
      EOS
    out = shell_output("#{bin}/cmark test.md")
    assert_match %r{<h1>Title</h1>.*<p>text</p>}m, out
  end
end
