require "formula"

class Mp3fs < Formula
  homepage "http://khenriks.github.io/mp3fs/"
  url "https://github.com/khenriks/mp3fs/releases/download/v0.91/mp3fs-0.91.tar.gz"
  sha1 "a9e65b8453f4444ec6faba045120e7efb18da20e"

  depends_on "pkg-config" => :build
  depends_on "lame"
  depends_on "osxfuse"
  depends_on "libid3tag"
  depends_on "flac"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    require "open3"
    Open3.popen3("#{bin}/mp3fs", "-V") do |_, stdout, _|
      assert_match /MP3FS version #{Regexp.escape(version)}/, stdout.read
    end
  end
end
