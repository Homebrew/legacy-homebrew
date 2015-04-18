class Conserver < Formula
  homepage "http://conserver.com"
  url "http://conserver.com/conserver-8.2.0.tar.gz"
  sha256 "a05beb7b66c0228ece62786c3cfe4b0048c5d508e072fb3631c2bf460cab904f"

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
