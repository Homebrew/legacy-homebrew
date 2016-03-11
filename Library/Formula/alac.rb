class Alac < Formula
  desc "Basic decoder for Apple Lossless Audio Codec files (ALAC)"
  homepage "https://web.archive.org/web/20150319040222/http://craz.net/programs/itunes/alac.html"
  url "https://web.archive.org/web/20150510210401/http://craz.net/programs/itunes/files/alac_decoder-0.2.0.tgz"
  sha256 "7f8f978a5619e6dfa03dc140994fd7255008d788af848ba6acf9cfbaa3e4122f"

  bottle do
    cellar :any_skip_relocation
    sha256 "4cb85c125553c6c2a49576790c5be5e0b89096569131df3b8576f3499e65ef5a" => :el_capitan
    sha256 "a3a54a254a147f3a1173870bdd2e9399043b3e506d8c04383f99cf3ce67a4fca" => :yosemite
    sha256 "20cca431ce69d7eb2e5d894ebbfffdbc633eef2b3447be6d0afdb7c25cac8c0e" => :mavericks
  end

  resource "sample" do
    url "http://download.wavetlan.com/SVV/Media/HTTP/AAC/iTunes/iTunes_test4_AAC-LC_v4_Stereo_VBR_128kbps_44100Hz.m4a"
    sha256 "c2b36e40aa48348837515172874db83c344bfe3fd9108956fb12c488be8e17d9"
  end

  def install
    system "make", "CFLAGS=#{ENV.cflags}", "CC=#{ENV.cc}"
    bin.install "alac"
  end

  test do
    resource("sample").stage do
      assert_equal "file type: mp4a\n",
        shell_output("#{bin}/alac -t iTunes_test4_AAC-LC_v4_Stereo_VBR_128kbps_44100Hz.m4a", 100)
    end
  end
end
