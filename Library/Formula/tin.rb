class Tin < Formula
  desc "Threaded, NNTP-, and spool-based UseNet newsreader"
  homepage "http://www.tin.org"
  url "http://ftp.cuhk.edu.hk/pub/packages/news/tin/v2.2/tin-2.2.1.tar.gz"
  sha256 "cf588884bbe4711498b807311e53d82a1b6ca343f4c85e53001c90e8c0e456ac"

  bottle do
    sha256 "1444c2fa1a3f63f4f8f8330b69d6c255c70c4732d13673a4beab2d621d753d3e" => :yosemite
    sha256 "11505b2e7b9953370a54fab8dc3460e28d3aabc1e02d2d713d514e4a78eb68d7" => :mavericks
    sha256 "231470502b1e124011bd79c44d84740d068ccc32aad86a5599e7006755e7a200" => :mountain_lion
  end

  devel do
    url "http://ftp.cuhk.edu.hk/pub/packages/news/tin/v2.3/tin-2.3.1.tar.gz"
    sha256 "d53ee03850988c96162f2a30a24f63a6976612f04fc049fd1e0c17d0d4567083"
  end

  conflicts_with "mutt", :because => "both install mmdf.5 and mbox.5 man pages"

  def install
    ENV.enable_warnings
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "build"
    system "make", "install"
  end

  test do
    system "#{bin}/tin", "-H"
  end
end
