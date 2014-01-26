require 'formula'

class Libsndfile < Formula
  homepage 'http://www.mega-nerd.com/libsndfile/'
  url 'http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.25.tar.gz'
  sha1 'e95d9fca57f7ddace9f197071cbcfb92fa16748e'

  depends_on 'pkg-config' => :build
  depends_on 'autoconf'
  depends_on 'automake'
  depends_on 'libtool'
  depends_on 'flac'
  depends_on 'libogg'
  depends_on 'libvorbis'

  option :universal

  def patches
    [
      # libsndfile doesn't find Carbon.h using XCode 4.3:
      # fixed upstream: https://github.com/erikd/libsndfile/commit/d04e1de82ae0af48fd09d5cb09bf21b4ca8d513c
      "https://gist.github.com/metabr/8623583/raw/90966b76c6f52e1293b5303541e1f2d72e2afd08/0001-libsndfile-doesn-t-find-Carbon.h-using-XCode-4.3.patch",
      # libsndfile fails to build with libvorbis 1.3.4
      # fixed upstream:
      # https://github.com/erikd/libsndfile/commit/d7cc3dd0a437cfb087e09c80c0b89dfd3ec80a54
      # https://github.com/erikd/libsndfile/commit/700ae0e8f358497dd614bcee8e4b93c629209b37
      # https://github.com/erikd/libsndfile/commit/50d1df56f7f9b90d0fafc618d4947611e9689ae9
      "https://gist.github.com/metabr/8623583/raw/cd3540f4abd8521edf0011ab6dd40888cfadfd7a/0002-libsndfile-fails-to-build-with-libvorbis-1.3.4.patch"
    ]
  end

  def install
    ENV.universal_binary if build.universal?

    system "autoreconf", "-i"
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
