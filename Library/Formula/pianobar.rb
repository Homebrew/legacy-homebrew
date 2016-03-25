class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://github.com/PromyLOPh/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2015.11.22.tar.bz2"
  sha256 "23fbc9e6f55b3277dba7a0f68ff721bad7f1eeea504c616ba008841686de322b"
  revision 2

  head "https://github.com/PromyLOPh/pianobar.git"

  bottle do
    cellar :any
    sha256 "ae2777bec3c7664e866ac6205357cee19f63bb8159e141ba0954151ffde90703" => :el_capitan
    sha256 "67d3706de8414abc75069b5e99d48f458f1f0cef76fbd2e3d136aed7c3143a8b" => :yosemite
    sha256 "5a13b2aa7a3374ef89e3f4c69bfadb334e6911bf8c4584d9bef588daac57cfc7" => :mavericks
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
