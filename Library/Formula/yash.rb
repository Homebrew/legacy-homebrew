class Yash < Formula
  desc "Yet another shell: a POSIX-compliant command-line shell"
  homepage "http://yash.osdn.jp"
  url "http://dl.osdn.jp/yash/62651/yash-2.37.tar.gz"
  sha256 "b976692de245ad3fb17bf87eb8b2e4c9bba4537e3820d488624c868e7408faaa"

  bottle do
    cellar :any
    sha256 "e155165566942ee1bde9cd71ef246ef0454befb2e5b23e43ac1eaca007fc8b46" => :yosemite
    sha256 "469eacccbb09edd965b099476fb616e8e3ecd10071f24c654ac525bde2e65721" => :mavericks
    sha256 "93538457f7f06a70634be8d1242bae4adb99ff3aac2518ae14b903fd987755ca" => :mountain_lion
  end

  def install
    system "sh", "./configure",
            "--prefix=#{prefix}",
            "--enable-alias",
            "--enable-array",
            "--enable-dirstack",
            "--enable-help",
            "--enable-history",
            "--enable-lineedit",
            "--disable-nls",
            "--enable-printf",
            "--enable-socket",
            "--enable-test",
            "--enable-ulimit"
    system "make", "install"
  end

  test do
    system "#{bin}/yash", "-c", "echo hello world"
  end
end
