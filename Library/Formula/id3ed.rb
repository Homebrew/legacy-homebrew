class Id3ed < Formula
  desc "ID3 tag editor for MP3 files"
  homepage "http://code.fluffytapeworm.com/projects/id3ed"
  url "http://code.fluffytapeworm.com/projects/id3ed/id3ed-1.10.4.tar.gz"
  sha256 "56f26dfde7b6357c5ad22644c2a379f25fce82a200264b5d4ce62f2468d8431b"

  bottle do
    cellar :any
    sha256 "8ca64da5c8c0cbbc7ec64af436fcf3a7ae457c8d8a8073887fc63ec4e89c98b9" => :yosemite
    sha256 "8dd4a14922e94245dd016a266aa23c7bcebb18a56e574c8179df83c2d68ff23c" => :mavericks
    sha256 "95311468f825fbf16c2a00151d01b641db11f6f8de905139845fff0f61e48e91" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--bindir=#{bin}/",
                          "--mandir=#{man1}"
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  test do
    system "#{bin}/id3ed", "-r", "-q", test_fixtures("test.mp3")
  end
end
