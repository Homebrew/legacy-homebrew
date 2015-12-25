class Lv2file < Formula
  desc "simple program which you can use to apply effects to your audio files"
  homepage "https://github.com/jeremysalwen/lv2file"
  url "https://github.com/jeremysalwen/lv2file/archive/upstream/0.84.tar.gz"
  sha256 "2c63498a76c52f6712e5e5d0bce8686efd407364e1218cf0a698f1a7e52ad979"

  head "https://github.com/jeremysalwen/lv2file.git"

  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "argtable"
  depends_on "libsndfile"
  depends_on "lilv"

  def install
    system "make", "BINDIR=#{bin}", "install"
  end

  test do
    assert_match "usage:", shell_output("#{bin}/lv2file 2>&1")
  end
end
