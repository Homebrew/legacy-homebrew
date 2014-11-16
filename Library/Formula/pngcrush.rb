require "formula"

# Stay at least one version behind and use the old-versions directory, because
# tarballs are routinely removed and upstream won't change this practice.
class Pngcrush < Formula
  homepage "http://pmt.sourceforge.net/pngcrush/"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.7.78/pngcrush-1.7.78.tar.gz"
  sha1 "9506a4106ecf1f960e8fe2c2a7e34131c234e070"

  bottle do
    cellar :any
    sha1 "1b873fdea03cfb4a23d1c98ae6e670d4de176ba9" => :yosemite
    sha1 "e2796d141f963d38341d295274e74987bada717e" => :mavericks
    sha1 "76fd5fcfdc145c5a926d47cc552323e7150ba085" => :mountain_lion
  end

  def install
    # Required to successfully build the bundled zlib 1.2.6
    ENV.append_to_cflags "-DZ_SOLO"
    # Required to enable "-cc" (color counting) option (disabled by default since 1.5.1)
    ENV.append_to_cflags "-DPNGCRUSH_COUNT_COLORS"

    system "make", "CC=#{ENV.cc}",
                   "LD=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "LDFLAGS=#{ENV.ldflags}"
    bin.install "pngcrush"
  end

  test do
    system "#{bin}/pngcrush", test_fixtures("test.png"), "/dev/null"
  end
end
