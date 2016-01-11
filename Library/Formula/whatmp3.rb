class Whatmp3 < Formula
  desc "Small script to create mp3 torrents out of FLACs"
  homepage "https://github.com/RecursiveForest/whatmp3"
  url "https://github.com/RecursiveForest/whatmp3/archive/v3.6.tar.gz"
  sha256 "a1f5ef28e2511aa47f4658f71a8a3afe3dda96e7dd6a1cf9d124daead0fed5fa"
  head "https://github.com/RecursiveForest/whatmp3.git"

  bottle :unneeded

  depends_on "python"
  depends_on "flac"
  depends_on "mktorrent" => :recommended
  depends_on "lame" => :recommended
  depends_on "vorbis-tools" => :optional
  depends_on "mp3gain" => :optional
  depends_on "aacgain" => :optional
  depends_on "vorbisgain" => :optional
  depends_on "sox" => :optional

  def install
    bin.install "whatmp3"
  end

  test do
    # Create dummy FLAC
    (testpath/"flac/file.flac").write "fLaC\x00\x00\x00\"\x04\x80\x04\x80\x00\x00\f\x00\x00\f\x01\xF4\x00\xF0\x00\x00\x00\x01\xF3\x8B\xE3\xDBM\x93\xE40\\~$\xBE\x94\xEF\x01\x9A\x84\x00\x00( \x00\x00\x00reference libFLAC 1.2.1 20070917\x00\x00\x00\x00\xFF\xF8d\b\x00\x00\xE3\x03\x01\xFD\xEC\x10"
    system "#{bin}/whatmp3", "--notorrent", "--V0", "flac"
    assert (testpath/"V0/file.mp3").exist?
  end
end
