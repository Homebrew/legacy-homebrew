require 'formula'

class Mapnik < Formula
  url 'https://github.com/downloads/mapnik/mapnik/mapnik-2.0.0.tar.bz2'
  homepage 'http://www.mapnik.org/'
  md5 '499c6a61544014b9bc2a7c978f963ef3'

  depends_on 'pkg-config' => :build
  depends_on 'libtiff'
  depends_on 'jpeg'
  depends_on 'proj'
  depends_on 'icu4c'
  depends_on 'boost'
  depends_on 'cairomm' => :optional

  def install
    ENV.append "PKG_CONFIG_PATH", "#{HOMEBREW_PREFIX}/pkgconfig"
    ENV.x11 # for freetype-config

    icu = Formula.factory("icu4c")
    system "python",
        "scons/scons.py",
        "configure",
        "CC=\"#{ENV['CC']}\"",
        "CXX=\"#{ENV['CXX']}\"",
        "JOBS=#{ENV.make_jobs}",
        "PREFIX=#{prefix}",
        "ICU_INCLUDES=#{icu.include}", "ICU_LIBS=#{icu.lib}"
    system "python",
        "scons/scons.py",
        "install"
  end
end
