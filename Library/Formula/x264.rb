class X264 < Formula
  homepage "https://www.videolan.org/developers/x264.html"
  # the latest commit on the stable branch
  url "https://git.videolan.org/git/x264.git", :revision => "c8a773ebfca148ef04f5a60d42cbd7336af0baf6"
  version "r2533"

  devel do
    # the latest commit on the master branch
    url "https://git.videolan.org/git/x264.git", :revision => "121396c71b4907ca82301d1a529795d98daab5f8"
    version "r2538"
  end

  head "https://git.videolan.org/git/x264.git"

  bottle do
    cellar :any
    sha1 "48aea1324df78e942257d63bcb9b1a0bbc32dfff" => :yosemite
    sha1 "1cb4086a82a0f41925bfddfd69d868b882ffe197" => :mavericks
    sha1 "f232c6e5ddad33c0b13e507c65cf760608957600" => :mountain_lion
  end

  depends_on "yasm" => :build

  option "with-10-bit", "Build a 10-bit x264 (default: 8-bit)"
  option "with-mp4=", "Select mp4 output: none (default), l-smash or gpac"

  deprecated_option "10-bit" => "with-10-bit"

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
