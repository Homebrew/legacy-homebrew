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
    revision 1
    sha1 "dd035a889bb65ba9ae9cc4815a4159e8d28a5ff2" => :yosemite
    sha1 "4dcf404cc4609578b5dffc94e2aff366f0a5d193" => :mavericks
    sha1 "a49c0943b4b420607c410f6736f9edf3d50704c2" => :mountain_lion
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

    # For running version.sh correctly
    buildpath.install_symlink cached_download/".git"

    system "./configure", *args
    system "make", "install"
  end
end
