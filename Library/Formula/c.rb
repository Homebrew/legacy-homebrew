class C < Formula
  homepage "https://github.com/ryanmjacobs/c"
  url "https://github.com/ryanmjacobs/c/archive/v0.07.tar.gz"
  sha1 "c40044a2747b97a2f8b550c1d417bb03848fcd40"

  depends_on "gnu-sed" # https://github.com/ryanmjacobs/c/issues/7

  def install
    bin.install "c"
  end

  test do
    system "echo", "int main(void){return 0;}", "|c"
  end
end
