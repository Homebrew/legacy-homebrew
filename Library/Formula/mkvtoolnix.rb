require 'formula'

class Mkvtoolnix < Formula
  homepage 'http://www.bunkus.org/videotools/mkvtoolnix/'
  url 'http://www.bunkus.org/videotools/mkvtoolnix/sources/mkvtoolnix-5.0.1.tar.bz2'
  sha1 '900211d47ba6cbeb4188bb45a492a2b9edf08ed2'

  head 'https://github.com/mbunkus/mkvtoolnix.git'

  depends_on 'boost149'
  depends_on 'libvorbis'
  depends_on 'libmatroska'
  depends_on 'flac' => :optional
  depends_on 'lzo' => :optional

  fails_with :clang do
    build 318
    cause "Compilation errors with older clang."
  end

  def install
    old_boost = Formula.factory("boost149")
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-boost=#{old_boost.prefix}",
                          "--with-boost-regex=boost_regex-mt" # via macports
    system "./drake", "-j#{ENV.make_jobs}"
    system "./drake install"
  end
end
