require "formula"

class X264 < Formula
  homepage "https://www.videolan.org/developers/x264.html"
  # the latest commit on the stable branch
  url "https://git.videolan.org/git/x264.git", :revision => "021c0dc6c95c1bc239c9db78a80dd85fc856a4dd"
  version "r2455"
  head "https://git.videolan.org/git/x264.git"

  devel do
    # the latest commit on the master branch
    url "https://git.videolan.org/git/x264.git", :revision => "dd79a61e0e354a432907f2d1f7137b27a12dfce7"
    version "r2479"
  end

  bottle do
    cellar :any
    sha1 "22085504fe0af795428e8098424534131d025d50" => :mavericks
    sha1 "d5dab543efc7abb240fff1c194bdae7b82244ee5" => :mountain_lion
    sha1 "f25f0a7c3ae891c2a229614da345774f93d9e1b7" => :lion
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
