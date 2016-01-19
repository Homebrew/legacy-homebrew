class Aacgain < Formula
  desc "AAC-supporting version of mp3gain"
  homepage "http://aacgain.altosdesign.com/"
  # This server will autocorrect a 1.9 url back to this 1.8 tarball.
  # The 1.9 version mentioned on the website is pre-release, so make
  # sure 1.9 is actually out before updating.
  # See: https://github.com/Homebrew/homebrew/issues/16838
  url "http://aacgain.altosdesign.com/alvarez/aacgain-1.8.tar.bz2"
  sha256 "2bb8e27aa8f8434a4861fdbc70adb9cb4b47e1dfe472910d62d6042cb80a2ee1"

  bottle do
    cellar :any
    sha256 "72ceb23c5d6c6a474470873eb42c7adabc8b723d4e828a6408a9c5f9ea915d70" => :yosemite
    sha256 "29b50db18863bba43907eeabac5221005cc1b2c733ef0f73efa2ff6264ff6bc0" => :mavericks
    sha256 "b4004c239d2443b4278b09222685ff19b8ca1b0dc8a39903db85966f4d57c1ab" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # aacgain modifies files in-place
    # See: https://github.com/Homebrew/homebrew/pull/37080
    cp test_fixtures("test.mp3"), "test.mp3"
    system "#{bin}/aacgain", "test.mp3"
  end
end
