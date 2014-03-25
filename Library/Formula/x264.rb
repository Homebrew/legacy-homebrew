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
    sha1 "ce6311ee8bb0ce64edd888bd9494b51ba4a91b46" => :mavericks
    sha1 "15f59b5c6965efd112cc7f6ecc4fcf76d0f1740a" => :mountain_lion
    sha1 "2667e3a601042682d9a1d4b7a9b69809b47c82e5" => :lion
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
