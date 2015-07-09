require 'formula'

class Vice < Formula
  desc "Versatile Commodore Emulator"
  homepage 'http://vice-emu.sourceforge.net/'
  url 'http://www.zimmers.net/anonftp/pub/cbm/crossplatform/emulators/VICE/vice-2.4.tar.gz'
  sha256 'ff8b8d5f0f497d1f8e75b95bbc4204993a789284a08a8a59ba727ad81dcace10'
  revision 1

  bottle do
    cellar :any
    sha256 "4cff2b9b091b5022a22ad6aecac097b02ca5fb4f2a1bb496a18ccac292c5cdeb" => :yosemite
    sha256 "00313217d8dcdb00695b9d38051459a5cbf42c65f3948a1c11da7b24e01d36e9" => :mavericks
    sha256 "5d9c7ccb0d373663a7bf89f9154b5943c5489e7b8a8b4c284066720265937518" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'jpeg'
  depends_on 'libpng'
  depends_on 'giflib' => :optional
  depends_on 'lame' => :optional

  fails_with :llvm do
    build 2335
  end

  def install
    # Use Cocoa instead of X
    # Use a static lame, otherwise Vice is hard-coded to look in
    # /opt for the library.
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-cocoa",
                          "--without-x",
                          "--enable-static-lame",
                          # VICE can't compile against FFMPEG newer than 0.11:
                          # http://sourceforge.net/tracker/?func=detail&aid=3585471&group_id=223021&atid=1057617
                          "--disable-ffmpeg"
    system "make"
    system "make bindist"
    prefix.install Dir['vice-macosx-*/*']
    bin.install_symlink Dir[prefix/'tools/*']
  end

  def caveats
    "Cocoa apps for these emulators have been installed to #{prefix}."
  end
end
