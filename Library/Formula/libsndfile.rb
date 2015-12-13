class Libsndfile < Formula
  desc "C library for files containing sampled sound"
  homepage "http://www.mega-nerd.com/libsndfile/"
  url "http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.26.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libs/libsndfile/libsndfile_1.0.26.orig.tar.gz"
  sha256 "cd6520ec763d1a45573885ecb1f8e4e42505ac12180268482a44b28484a25092"

  bottle do
    cellar :any
    revision 1
    sha256 "55cacc1278d4f6d2d4843670b8313f1b06ffdaf9bad4c7e9498f2df5246726ee" => :el_capitan
    sha256 "a38457a5911d0b90af9111a45645cdfd5db8c6d04b735cf739140b45a64bcc73" => :yosemite
    sha256 "417c53b60c1841abb95ed9c315dbec323268b64f40114dd8e02101db144716c0" => :mavericks
    sha256 "dd758a335e998b68e8a673ec64ab989f2257b0895a485fc7f0a13ccec707e75a" => :mountain_lion
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
