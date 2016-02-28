class Ficy < Formula
  desc "Icecast/Shoutcast stream grabber suite"
  homepage "https://www.thregr.org/~wavexx/software/fIcy/"
  url "https://www.thregr.org/~wavexx/software/fIcy/releases/fIcy-1.0.19.tar.gz"
  sha256 "397df996fd63ce8608e62b195af61e88b0571aac01a51f1935dbf639c5424dcb"

  head "https://github.com/wavexx/fIcy.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "16c55392bb663480719ea585e7897851b8c3af789fdeed93e610b978d1167b2f" => :el_capitan
    sha256 "e549c781d232c77be4628f2ad48f4511a226f0bd4f81b930629336af490f20aa" => :yosemite
    sha256 "ceaaa6fe572fec4e2d14701e62696616f728b8f1dd29eae787afe19bdfdf70e6" => :mavericks
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
