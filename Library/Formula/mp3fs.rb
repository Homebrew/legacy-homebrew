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
    assert_match /mp3fs version: #{Regexp.escape(version)}/,
                 shell_output("#{bin}/mp3fs -V")
  end
end
