class Nbc < Formula
  homepage "https://github.com/chiayolin/nbc/"
  url "https://github.com/chiayolin/nbc/archive/0.1.tar.gz"
  sha1 "e57a50a723be9efc23173509fd4bf1161c75c846"

  def install
    cd "src" do
      system "make"
      bin.install "nbc"
    end
  end

  test do
    system bin/"nbc", "-m"
  end
end
