require "formula"

# Stay at least one version behind and use the old-versions directory, because
# tarballs are routinely removed and upstream won't change this practice.
class Pngcrush < Formula
  homepage "http://pmt.sourceforge.net/pngcrush/"
  url "https://downloads.sourceforge.net/project/pmt/pngcrush/1.7.77/pngcrush-1.7.77.tar.gz"
  sha1 "70e15781220a0095453d04b040c6f42d77487d7b"

  bottle do
    cellar :any
    sha1 "4fbc1d4dd08adb4f3278cb6422140207c96e01f7" => :mavericks
    sha1 "bca5fc1cf30f862aed221275ffb7eb3596409789" => :mountain_lion
    sha1 "4dc287b68464aefd6ac9fc47ddb6d2942c75d3e7" => :lion
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
end
