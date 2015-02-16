class X264 < Formula
  homepage "https://www.videolan.org/developers/x264.html"
  # the latest commit on the stable branch
  url "https://git.videolan.org/git/x264.git", :revision => "6a301b6ee0ae8c78fb704e1cd86f4e861070f641"
  version "r2495"

  devel do
    # the latest commit on the master branch
    url "https://git.videolan.org/git/x264.git", :revision => "40bb56814e56ed342040bdbf30258aab39ee9e89"
    version "r2525"
  end

  head "https://git.videolan.org/git/x264.git"

  bottle do
    cellar :any
    sha1 "48aea1324df78e942257d63bcb9b1a0bbc32dfff" => :yosemite
    sha1 "1cb4086a82a0f41925bfddfd69d868b882ffe197" => :mavericks
    sha1 "f232c6e5ddad33c0b13e507c65cf760608957600" => :mountain_lion
  end

  depends_on "yasm" => :build

  option "10-bit", "Build a 10-bit x264 (default: 8-bit)"
  option "with-mp4=", "Select mp4 output: none (default), l-smash or gpac"

  case ARGV.value "with-mp4"
  when "l-smash" then depends_on "l-smash"
  when "gpac" then depends_on "gpac"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-static
      --enable-strip
    ]
    if Formula["l-smash"].installed?
      args << "--disable-gpac"
    elsif Formula["gpac"].installed?
      args << "--disable-lsmash"
    end
    args << "--bit-depth=10" if build.include? "10-bit"

    system "./configure", *args
    system "make", "install"
  end
end
