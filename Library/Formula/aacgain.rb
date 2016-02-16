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
    cellar :any_skip_relocation
    sha256 "b97aaaf19fee69734b4a29e22c498becaa94b3025a192a7ef8f1ecfb0a2ce87c" => :el_capitan
    sha256 "5c01278c495e8a67b7af02f6355ac6a79ce6b4caa5148503346eb33e7d26b70a" => :yosemite
    sha256 "9bf1cb0bf030d70bb37a311b92621747d02379cb7f6ae6734bcb4239bdb9d4e6" => :mavericks
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
