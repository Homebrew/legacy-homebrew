class Picocom < Formula
  desc "Minimal dump-terminal emulation program"
  homepage "https://github.com/npat-efault/picocom"
  url "https://github.com/npat-efault/picocom/archive/2.1.tar.gz"
  sha256 "6b152fc5f816eaef6b86336a4cec7cf1496b7c712061e5aea5a36f143a0b09ed"

  def install
    system "make"
    bin.install "picocom"
    man1.install "picocom.1"
  end

  test do
    system "#{bin}/picocom", "--help"
  end
end
