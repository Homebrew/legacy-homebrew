class Lv < Formula
  desc "Powerful multi-lingual file viewer/grep"
  homepage "http://www.ff.iij4u.or.jp/~nrt/lv/"
  url "http://www.ff.iij4u.or.jp/~nrt/freeware/lv451.tar.gz"
  version "4.51"
  sha256 "e1cd2e27109fbdbc6d435f2c3a99c8a6ef2898941f5d2f7bacf0c1ad70158bcf"

  bottle do
    sha256 "f9d97339cfc34f5204cef5209e0a451181a05867e5230741bf09fcda93dfa370" => :mavericks
    sha256 "e783717408f9810e18770270dc2b6ecd0ab4f5c9f18e84c4f9fa37ec9fe7c6b7" => :mountain_lion
    sha256 "ffc51473182eb7a48a2e9efdc081a8e12b2ebf346f88239f42147cb5acfe7104" => :lion
  end

  def install
    # zcat doesn't handle gzip'd data on OSX.
    # Reported upstream to nrt@ff.iij4u.or.jp
    inreplace "src/stream.c", 'gz_filter = "zcat"', 'gz_filter = "gzcat"'

    cd "build" do
      system "../src/configure", "--prefix=#{prefix}"
      system "make"
      bin.install "lv"
      bin.install_symlink "lv" => "lgrep"
    end

    man1.install "lv.1"
    (lib+"lv").install "lv.hlp"
  end
end
