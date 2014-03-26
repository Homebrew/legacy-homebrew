require 'formula'

class X264 < Formula
  homepage "http://www.videolan.org/developers/x264.html"
  # the latest commit on the stable branch
  url "http://git.videolan.org/git/x264.git", :revision => "aff928d2a2f601072cebecfd1ac5ff768880cf88"
  version "r2397"
  head "http://git.videolan.org/git/x264.git"

  devel do
    # the latest commit on the master branch
    url "http://git.videolan.org/git/x264.git", :revision => "d6b4e63d2ed8d444b77c11b36c1d646ee5549276"
    version "r2409"
  end

  # Support building with Clang 3.4
  # The patch will be merged in the official repository soon.
  patch do
    url "https://github.com/DarkShikari/x264-devel/commit/bc3b27.patch"
    sha1 "6c3d1bc241c64d8df64273df403d43e3116bd567"
  end

  bottle do
    cellar :any
    sha1 "7a35f1da2e78eedb2be6d8f44d4bd1bc2a62339d" => :mavericks
    sha1 "1b55c37b83f95a589b1832ccab7d8dae3700f5dc" => :mountain_lion
    sha1 "19c9d9a6df12cbc4a6201c044215d2be609e6844" => :lion
  end

  depends_on 'yasm' => :build

  option '10-bit', 'Build a 10-bit x264 (default: 8-bit)'

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --enable-static
      --enable-strip
    ]
    args << "--bit-depth=10" if build.include? '10-bit'

    # For running version.sh correctly
    buildpath.install_symlink cached_download/".git"

    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Because libx264 has a rapidly-changing API, formulae that link against
    it should be reinstalled each time you upgrade x264. Examples include:
       avidemux, ffmbc, ffmpeg, gst-plugins-ugly
    EOS
  end
end
