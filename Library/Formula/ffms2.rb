require "formula"

class Ffms2 < Formula
  homepage "https://github.com/FFMS/ffms2"
  url "https://github.com/FFMS/ffms2/archive/2.20.tar.gz"
  sha1 "bf09d8ed54e5aad86b352b4d335d29da016f2014"

  depends_on 'pkg-config' => :build
  depends_on 'ffmpeg'

  # needed for the test to exit cleanly
  patch do
    url "https://github.com/FFMS/ffms2/commit/2c59b6a420bc8cf35fc8552a37a63d7d6e1ef424.patch"
    sha1 "c96d95264cef354ae11ba02421f36568fd50f88d"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-avresample",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "ffmsindex"
  end
end
