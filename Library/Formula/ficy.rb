class Ficy < Formula
  homepage "http://www.thregr.org/~wavexx/software/fIcy/"
  url "http://www.thregr.org/~wavexx/software/fIcy/releases/fIcy-1.0.19.tar.gz"
  sha256 "397df996fd63ce8608e62b195af61e88b0571aac01a51f1935dbf639c5424dcb"

  head "https://github.com/wavexx/fIcy.git"

  def install
    system "make"
    bin.install "fIcy", "fPls", "fResync"
  end

  test do
    cp test_fixtures("test.mp3"), testpath
    system "#{bin}/fResync", "-n", "1", "test.mp3"
  end
end
