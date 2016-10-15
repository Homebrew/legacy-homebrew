require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook

class Knowthelist < Formula
  homepage "http://knowthelist.github.io/knowthelist"
  url "https://github.com/knowthelist/knowthelist/archive/v2.2.2.tar.gz"
  sha1 "0019ddabe094b057b2c150bd50b7fd4b077ff897"
  head "https://github.com/knowthelist/knowthelist.git"

  depends_on "homebrew/versions/gstreamer010"
  depends_on "gst-plugins-base010"
  depends_on "gst-plugins-good010"
  depends_on "gst-plugins-ugly010" => "with-mad"
  depends_on "taglib"
  depends_on 'qt'

  def install
    system "qmake"
    system "make"
    bin.install buildpath/"knowthelist.app"
    system "cp -R #{bin}/knowthelist.app /Applications"
  end

  test do
    system "false"
  end
end
