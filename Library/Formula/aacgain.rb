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
    sha1 "a90e244d0c89d787d1687ef2adb482624f6d2bb8" => :yosemite
    sha1 "0a5c772e3ca281678d468dec7757df7517f9ae1e" => :mavericks
    sha1 "98f1d3415005700417fc8116d0428a0df975b2e4" => :mountain_lion
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
