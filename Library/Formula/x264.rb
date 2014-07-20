require 'formula'

class X264 < Formula
  homepage "http://www.videolan.org/developers/x264.html"
  # the latest commit on the stable branch
  url "http://git.videolan.org/git/x264.git", :revision => "d7e689680023e327de7e052e01e7faee30135799"
  version "r2412"
  head "http://git.videolan.org/git/x264.git"

  devel do
    # the latest commit on the master branch
    url "http://git.videolan.org/git/x264.git", :revision => "a5831aa256b3161f898d2577d2eb8daa838d88d2"
    version "r2431"
  end

  bottle do
    cellar :any
    revision 1
    sha1 "6372fb019be6bc04374ff0152e8a5b6b84938176" => :mavericks
    sha1 "ffcc0096d06f4c129c8b71d4c584cd42af2e8572" => :mountain_lion
    sha1 "002522775ea0f47987b633528b22eb6e3ea5d43b" => :lion
  end

  depends_on 'yasm' => :build

  option '10-bit', 'Build a 10-bit x264 (default: 8-bit)'
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
    args << "--bit-depth=10" if build.include? '10-bit'

    # For running version.sh correctly
    buildpath.install_symlink cached_download/".git"

    system "./configure", *args
    system "make", "install"
  end
end
