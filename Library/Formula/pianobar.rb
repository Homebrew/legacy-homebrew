class Pianobar < Formula
  desc "Command-line player for https://pandora.com"
  homepage "https://github.com/PromyLOPh/pianobar/"
  url "https://6xq.net/pianobar/pianobar-2015.11.22.tar.bz2"
  sha256 "23fbc9e6f55b3277dba7a0f68ff721bad7f1eeea504c616ba008841686de322b"
  revision 1

  head "https://github.com/PromyLOPh/pianobar.git"

  bottle do
    cellar :any
    sha256 "16428a35d4a9726a41fe84432f3f5a8bdc6e851dbce3d4859548478fe4f2f3d2" => :el_capitan
    sha256 "9d1166dc514af671b40a4508f41f2b714c26c17ec226d58c8a5977e1cb80a530" => :yosemite
    sha256 "15c7a6e24c8f5b847c210e9fa3c5046cdda5c72dbde4384d877b321322f5f145" => :mavericks
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
