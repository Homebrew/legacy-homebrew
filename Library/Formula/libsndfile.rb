class Libsndfile < Formula
  desc "C library for files containing sampled sound"
  homepage "http://www.mega-nerd.com/libsndfile/"
  url "http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.25.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libs/libsndfile/libsndfile_1.0.25.orig.tar.gz"
  sha256 "59016dbd326abe7e2366ded5c344c853829bebfd1702ef26a07ef662d6aa4882"

  bottle do
    cellar :any
    revision 1
    sha1 "6bbba8972b492d3a287e6f10d39115ca980224ec" => :yosemite
    sha1 "07d424bd9d4f051495538edd0899b191495457c5" => :mavericks
    sha1 "9ed12d6cc31e2a63d14fb175bba7b5d68145cc94" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"

  option :universal

  # libsndfile doesn't find Carbon.h using XCode 4.3:
  # fixed upstream: https://github.com/erikd/libsndfile/commit/d04e1de82ae0af48fd09d5cb09bf21b4ca8d513c
  patch do
    url "https://gist.githubusercontent.com/metabr/8623583/raw/90966b76c6f52e1293b5303541e1f2d72e2afd08/0001-libsndfile-doesn-t-find-Carbon.h-using-XCode-4.3.patch"
    sha256 "6b5fd749ef3b4990ca011eb65289c369cff82285e99773e4a74de4615f082df5"
  end

  # libsndfile fails to build with libvorbis 1.3.4
  # fixed upstream:
  # https://github.com/erikd/libsndfile/commit/d7cc3dd0a437cfb087e09c80c0b89dfd3ec80a54
  # https://github.com/erikd/libsndfile/commit/700ae0e8f358497dd614bcee8e4b93c629209b37
  # https://github.com/erikd/libsndfile/commit/50d1df56f7f9b90d0fafc618d4947611e9689ae9
  patch do
    url "https://gist.githubusercontent.com/metabr/8623583/raw/cd3540f4abd8521edf0011ab6dd40888cfadfd7a/0002-libsndfile-fails-to-build-with-libvorbis-1.3.4.patch"
    sha256 "00697cfe8e13e6d4b36f6ad6327dd670be5a6542371b2ccabcc3175527731a41"
  end

  def install
    ENV.universal_binary if build.universal?

    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
