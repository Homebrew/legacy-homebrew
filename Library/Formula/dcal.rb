class Dcal < Formula
  homepage "http://alexeyt.freeshell.org/"
  url "http://alexeyt.freeshell.org/code/dcal.c"
  version "0.1.0"
  sha256 "d637fd27fc8d2a3c567b215fc05ee0fd9d88ba9fc5ddd5f0b07af3b8889dcba7"

  def install
    system ENV.cxx, "dcal.c", "-o", "dcal"
    bin.install "dcal"
  end

  test do
    system "#{bin}/dcal", "-3"
  end
end
