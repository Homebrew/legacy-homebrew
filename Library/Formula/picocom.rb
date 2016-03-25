class Picocom < Formula
  desc "Minimal dump-terminal emulation program"
  homepage "https://github.com/npat-efault/picocom"
  url "https://github.com/npat-efault/picocom/archive/2.1.tar.gz"
  sha256 "6b152fc5f816eaef6b86336a4cec7cf1496b7c712061e5aea5a36f143a0b09ed"

  bottle do
    cellar :any_skip_relocation
    sha256 "f45b55ceb211413c32d769a45db1f0b5588143a183b570509502f7c3c8fc6770" => :el_capitan
    sha256 "b4a7c54a0333c78b186cbcdccecc44676967f5284d11695010c182074deed443" => :yosemite
    sha256 "c7a9665b8ea06236a251be26a945f47d8720e302dc004306ab95c7e19abf9079" => :mavericks
  end

  def install
    system "make"
    bin.install "picocom"
    man1.install "picocom.1"
  end

  test do
    system "#{bin}/picocom", "--help"
  end
end
