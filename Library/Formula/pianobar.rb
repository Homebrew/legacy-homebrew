class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://github.com/PromyLOPh/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2015.11.22.tar.bz2"
  sha256 "23fbc9e6f55b3277dba7a0f68ff721bad7f1eeea504c616ba008841686de322b"
  head "https://github.com/PromyLOPh/pianobar.git"

  bottle do
    cellar :any
    sha256 "af31da8a1c37f0c8a96cb3ac0dc77729273876c9fbf297b3ad8bac760c5c5a93" => :el_capitan
    sha256 "9391c326669a36450344beaf238585882694bd302fff41fbb3ce70bd3061090f" => :yosemite
    sha256 "c9173c98d827a8ab01faefe581512cb19ff27d6a01ec2356db00ce3a9e21e028" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libao"
  depends_on "mad"
  depends_on "faad2"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "json-c"
  depends_on "ffmpeg"

  fails_with :llvm do
    build 2334
    cause "Reports of this not compiling on Xcode 4"
  end

  def install
    # Discard Homebrew's CFLAGS as Pianobar reportedly doesn't like them
    ENV["CFLAGS"] = "-O2 -DNDEBUG " +
                    # Or it doesn't build at all
                    "-std=c99 " +
                    # build if we aren't /usr/local'
                    "#{ENV.cppflags} #{ENV.ldflags}"
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"

    prefix.install "contrib"
  end
end
