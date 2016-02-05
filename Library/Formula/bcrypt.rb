class Bcrypt < Formula
  desc "Cross platform file encryption utility using blowfish"
  homepage "http://bcrypt.sourceforge.net"
  url "http://bcrypt.sourceforge.net/bcrypt-1.1.tar.gz"
  sha256 "b9c1a7c0996a305465135b90123b0c63adbb5fa7c47a24b3f347deb2696d417d"

  bottle do
    cellar :any
    sha256 "dbd530bd84a1e92120aacf07f60e3b6131c92421702ab8b9f9e02d3b72a00ad6" => :yosemite
    sha256 "2a0a662d778677d75222745b30e6c5e825078855d303cf853609f50b1ceca4a6" => :mavericks
    sha256 "7f9c94e9c1527e596b316746d9705f524afb70c661abeb1279bf2c88ad061ddf" => :mountain_lion
  end

  def install
    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=-lz"
    bin.install "bcrypt"
    man1.install gzip("bcrypt.1")
  end

  test do
    (testpath/"test.txt").write("Hello World!")
    pipe_output("#{bin}/bcrypt -r test.txt", "12345678\n12345678\n")
    mv "test.txt.bfe", "test.out.txt.bfe"
    pipe_output("#{bin}/bcrypt -r test.out.txt.bfe", "12345678\n")
    assert_equal File.read("test.txt"), File.read("test.out.txt")
  end
end
