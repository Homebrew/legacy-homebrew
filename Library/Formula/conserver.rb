class Conserver < Formula
  desc "Allows multiple users to watch a serial console at the same time"
  homepage "http://conserver.com"
  url "http://conserver.com/conserver-8.2.1.tar.gz"
  sha256 "251ae01997e8f3ee75106a5b84ec6f2a8eb5ff2f8092438eba34384a615153d0"

  bottle do
    sha256 "124e2eab8cea657ee17fea2ed6c9bd5592f172fa401b72f63f37299989a36b22" => :yosemite
    sha256 "faa174dbcf430a5410654ce87e2cc69bd0ee4382f253dff38ff5ee4f992c259d" => :mavericks
    sha256 "81aee0e591a8c878a55cf173c0d9b70e3539bb7cebbd81466ffabd270ee07ce2" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    console = fork do
      system bin/"console", "-n", "-p", "8000", "test"
    end
    sleep 1
    Process.kill("TERM",console)
  end
end
