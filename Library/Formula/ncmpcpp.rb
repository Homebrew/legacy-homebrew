require 'formula'

class Ncmpcpp <Formula
  url 'http://unkart.ovh.org/ncmpcpp/ncmpcpp-0.5.5.tar.bz2'
  homepage 'http://unkart.ovh.org/ncmpcpp'
  md5 '30cded976c81bba4c8a2daf2215fe41d'
  version '0.5.5'

  depends_on 'pkg-config' => :build
  depends_on 'libmpdclient'
  depends_on 'libiconv'
  depends_on 'taglib' => :optional
  depends_on 'fftw' if ARGV.include? "--enable-visualizer"

  def options
    [
      ["--enable-visualizer", "Enable music visualizer screen"]
    ]
  end

  def install
    configure_flags = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}"
    ]

    configure_flags << "--without-taglib" unless Formula.factory('taglib').installed?
    configure_flags << "--enable-visualizer" if ARGV.include? "--enable-visualizer"

    system "./configure", *configure_flags

    system "make install"
  end
end
