class Pianobar < Formula
  desc "Command-line player for http://pandora.com"
  homepage "https://github.com/PromyLOPh/pianobar/"
  url "http://6xq.net/pianobar/pianobar-2015.11.22.tar.bz2"
  sha256 "23fbc9e6f55b3277dba7a0f68ff721bad7f1eeea504c616ba008841686de322b"
  head "https://github.com/PromyLOPh/pianobar.git"

  bottle do
    cellar :any
    revision 1
    sha256 "02b39caa7b8e62aa061d8bb416e914c4ad3002073eb47d541a04c3437f8e92cc" => :yosemite
    sha256 "ad95ed05407af335e80867e06379e898036745aa7a92b5438de255cfd22e4e12" => :mavericks
    sha256 "f2c38f52caa79e5a4aa2c852d2b0bcf72f59c15eef21ec2e186d3520752d2506" => :mountain_lion
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
