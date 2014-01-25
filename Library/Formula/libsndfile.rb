require 'formula'

class Libsndfile < Formula
  homepage 'http://www.mega-nerd.com/libsndfile/'
  url 'http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.25.tar.gz'
  sha1 'e95d9fca57f7ddace9f197071cbcfb92fa16748e'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build
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
      # fixed in FINK: http://fink.cvs.sourceforge.net/viewvc/fink/dists/10.7/stable/main/finkinfo/sound/libsndfile1.patch?revision=1.2&view=markup
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
