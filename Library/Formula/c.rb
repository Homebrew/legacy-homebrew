class C < Formula
  homepage "https://github.com/ryanmjacobs/c"
  url "https://github.com/ryanmjacobs/c/archive/v0.09.tar.gz"
  sha1 "a17ad8071d68cb8ce9b3e0f11cff8ff9701f2792"

  def install
    bin.install "c"
  end

  test do
    system "echo", "int main(void){return 0;}", "|c"
  end
end
