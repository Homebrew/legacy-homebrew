class Whatmp3 < Formula
  desc "whatmp3 is a small script to create mp3 torrents out of FLACs."
  homepage "https://github.com/RecursiveForest/whatmp3"
  url "https://github.com/RecursiveForest/whatmp3/archive/v3.6.tar.gz"
  sha256 "a1f5ef28e2511aa47f4658f71a8a3afe3dda96e7dd6a1cf9d124daead0fed5fa"
  head "https://github.com/RecursiveForest/whatmp3.git"

  depends_on "python"
  depends_on "flac"
  depends_on "mktorrent" => :recommended
  depends_on "vorbis-tools" => :optional
  depends_on "lame" => :optional
  depends_on "mp3gain" => :optional
  depends_on "aacgain" => :optional
  depends_on "vorbisgain" => :optional
  depends_on "sox" => :optional

  def install
    bin.install "whatmp3"
  end

  test do
    # Create dummy FLAC
    Dir.mkdir("flac")
    raw_data = "pseudo audio data that stays the same \x00\xff\xda"
    (testpath/"file.raw").write raw_data
    system "flac", "--endian=little", "--sign=signed", "--channels=1", "--bps=8", "--sample-rate=8000", "--output-name=flac/file.flac", "file.raw"
    # Decode with Whatmp3
    system "#{bin}/whatmp3", "--notorrent", "--V0", "flac"
    assert (testpath/"V0/file.mp3").exist?
  end
end
