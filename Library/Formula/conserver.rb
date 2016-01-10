class Conserver < Formula
  desc "Allows multiple users to watch a serial console at the same time"
  homepage "http://conserver.com"
  url "http://conserver.com/conserver-8.2.1.tar.gz"
  sha256 "251ae01997e8f3ee75106a5b84ec6f2a8eb5ff2f8092438eba34384a615153d0"

  bottle do
    sha256 "0afc8a0539f05c8226c0d75775558e98f42e597e2e9755988164dc5f2e0f3cf7" => :yosemite
    sha256 "40af1ae864c47df564f22760f96969c3a6e9575610d9cd1d3348b44d6eef5a9e" => :mavericks
    sha256 "88887688a6de1d1cb9ed36899477e16ef233b80392854220291fa1a5499ea833" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    console = fork do
      exec bin/"console", "-n", "-p", "8000", "test"
    end
    sleep 1
    Process.kill("TERM", console)
  end
end
