require 'formula'

class Mednafen < Formula
  homepage 'http://mednafen.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/mednafen/Mednafen/0.8.D.3/mednafen-0.8.D.3.tar.bz2'
  md5 '57d22805071becd81858b0c088a275e5'
  version '0.8.D.3'

  devel do
    url 'http://forum.fobby.net/index.php?t=getfile&id=304'
    md5 '0327b3b0f8413f1ed446c4d8b9b897f0'
    version '0.9.18-WIP'
  end

  depends_on 'pkg-config' => :build
  depends_on 'sdl'
  depends_on 'sdl_net'
  depends_on 'libcdio'
  depends_on 'libsndfile'

  def options
    [
      ["--with-psx", "Build experimental PlayStation emulator"]
    ]
  end

  def install
    # Compiler produces code which fails math tests
    # with optimizations enabled
    # http://forum.fobby.net/index.php?t=msg&&th=659&goto=2254#msg_2254
    ENV.no_optimization

    args = [ "--disable-dependency-tracking", "--prefix=#{prefix}" ]

    if ARGV.include? "--with-psx" and not ARGV.build_devel?
      onoe "--with-psx is only supported with --devel" \
    end
    args << "--enable-psx" if ARGV.include? "--with-psx" and ARGV.build_devel?

    # Platform detection is buggy; problem reported upstream:
    # http://forum.fobby.net/index.php?t=msg&&th=659&goto=2214#msg_2214
    args << "--build=x86_64-apple-darwin#{`uname -r`}" if MacOS.prefer_64_bit?

    system "./configure", *args
    system "make install"
  end
end
