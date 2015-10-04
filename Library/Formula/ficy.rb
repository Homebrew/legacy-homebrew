class Ficy < Formula
  desc "Icecast/Shoutcast stream grabber suite"
  homepage "http://www.thregr.org/~wavexx/software/fIcy/"
  url "http://www.thregr.org/~wavexx/software/fIcy/releases/fIcy-1.0.19.tar.gz"
  sha256 "397df996fd63ce8608e62b195af61e88b0571aac01a51f1935dbf639c5424dcb"

  head "https://github.com/wavexx/fIcy.git"

  bottle do
    cellar :any
    sha256 "ad3aa8d4d6fb4f80f93b4d6c021b1b22f4fbe70a761dd6ff559dd384621d503e" => :yosemite
    sha256 "19606f6659322c49f2b46c042090a95b5dca1f92ade03b9208c48ffd3a00f2fd" => :mavericks
    sha256 "16ca10e95e5ad7736193a2ffe95aaaf0008415390b7ed9791858b3abfe49c48b" => :mountain_lion
  end

  def install
    system "make"
    bin.install "fIcy", "fPls", "fResync"
  end

  test do
    cp test_fixtures("test.mp3"), testpath
    system "#{bin}/fResync", "-n", "1", "test.mp3"
  end
end
