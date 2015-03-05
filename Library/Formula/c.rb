class C < Formula
  homepage "https://github.com/ryanmjacobs/c"
  url "https://github.com/ryanmjacobs/c/archive/v0.07.tar.gz"
  sha1 "c40044a2747b97a2f8b550c1d417bb03848fcd40"

  depends_on "gnu-sed"

  def install
      bin.install "c"
  end

  test do
    Dir.chdir("tests") do
      system "test.sh"
    end
  end
end
