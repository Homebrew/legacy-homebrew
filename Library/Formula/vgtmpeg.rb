require 'formula'

class Vgtmpeg < Formula
  homepage 'http://godromo.com/gmt/vgtmpeg'
  url 'http://static.mouseed.com/src/vgtmpeg/vgtmpeg-1.3.22.tar.bz2'
  mirror 'https://bitbucket.org/forlab/brew-formulas/src/f2f7ec5da74b/Sources/vgtmpeg/vgtmpeg-1.3.22.tar.bz2'
  head 'git://github.com/concalma/vgtmpeg.git'
  md5 '927ec3b2d4075eef6bf2ec7077fc3dfb'

  depends_on 'yasm' => :build
  depends_on 'libdvdread'
  depends_on 'libbluray'
  depends_on 'x264'      => :optional
  depends_on 'faac'      => :optional
  depends_on 'lame'      => :optional
  depends_on 'theora'    => :optional
  depends_on 'libvorbis' => :optional
  depends_on 'libvpx'    => :optional
  depends_on 'xvid'      => :optional
  
  fails_with :llvm do
    build 5658
    cause 'Undefined symbols when linking libavfilter'
  end

  def install
    args = [
      "--prefix=#{prefix}", 
      "--mandir=#{man}",
      "--disable-debug",
      "--enable-shared",
      "--enable-gpl",
      "--enable-version3",
      "--enable-nonfree",
      "--enable-hardcoded-tables",
      "--cc=#{ENV.cc}"
    ]
    
    args << "--enable-libx264" if Formula.factory('x264').installed?
    args << "--enable-libfaac" if Formula.factory('faac').installed?
    args << "--enable-libmp3lame" if Formula.factory('lame').installed?
    args << "--enable-libtheora" if Formula.factory('theora').installed?
    args << "--enable-libvorbis" if Formula.factory('libvorbis').installed?
    args << "--enable-libvpx" if Formula.factory('libvpx').installed?
    args << "--enable-libxvid" if Formula.factory('xvid').installed?

    system "./configure", *args
    system "make"
    system "make install"
  end
  
  def test
    system "#{bin}/vgtmpeg -version"
  end
end
