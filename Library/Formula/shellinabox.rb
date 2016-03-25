class Shellinabox < Formula
  desc "Export command-line tools to web based terminal emulator"
  homepage "https://github.com/shellinabox/shellinabox"
  url "https://github.com/shellinabox/shellinabox/archive/v2.19.tar.gz"
  sha256 "d25ba9f72f04471fc1a8a564c65ef466c4553280ff3eeb365ed9c897d05ed2da"

  bottle do
    cellar :any_skip_relocation
    sha256 "1502d88ce75b94a3cefd4ccc1d65e9c892a02abc754b0027e99b889d22b6989a" => :el_capitan
    sha256 "28a52a963f3cdc8068b4843b2974ccf977cd676f6adf20c126321ed0845f29ea" => :yosemite
    sha256 "5a7ab0bccaaa3687e986f040e0bf1eb12701feecb3e0db6114a5c7cdc1cdfe73" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/shellinaboxd", "--version"
  end
end
