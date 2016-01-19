class Rarian < Formula
  desc "Documentation metadata library"
  homepage "http://rarian.freedesktop.org/"
  url "http://rarian.freedesktop.org/Releases/rarian-0.8.1.tar.bz2"
  sha256 "aafe886d46e467eb3414e91fa9e42955bd4b618c3e19c42c773026b205a84577"

  bottle do
    sha256 "7784dc13b95c0c2f5818bc3657da52f0365bbe9c6ddf8871d81b8638cb89390c" => :el_capitan
    sha256 "069ff9e17c252271d058e72f38eedb2e1196cee49598e1537c64bd45b7f356e6" => :yosemite
    sha256 "1a81d2fe1bb961b9b479da410046f24fa65df8db7cac5ee0853cc09f380f6bc4" => :mavericks
    sha256 "a8ee74028d7921184683bb480d5ce823d834e9e0d36ede4c18c1d795ba138a2d" => :mountain_lion
  end

  conflicts_with "scrollkeeper",
    :because => "rarian and scrollkeeper install the same binaries."

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
