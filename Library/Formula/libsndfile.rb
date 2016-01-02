class Libsndfile < Formula
  desc "C library for files containing sampled sound"
  homepage "http://www.mega-nerd.com/libsndfile/"
  url "http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.26.tar.gz"
  sha256 "cd6520ec763d1a45573885ecb1f8e4e42505ac12180268482a44b28484a25092"

  bottle do
    cellar :any
    sha256 "14fb9d6ecd9bf39fce4d59b7d772edad94566e60e922724f014f034f7e343992" => :el_capitan
    sha256 "5817f2567471377ce161172d58059cd0cfcbbe9cb1e5f6eb80b501a629d40b5f" => :yosemite
    sha256 "a5700a479cafd48d22e2032d95207abcd2d43fc56015348684522b8a61eb4f04" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"

  def install
    ENV.universal_binary if build.universal?

    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
