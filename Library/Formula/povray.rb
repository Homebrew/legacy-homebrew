require 'formula'

class NeedsLion < Requirement
  fatal true
  satisfy MacOS.version >= :lion

  def message; <<-EOS.undent
    PovRay 3.7.0.RC6 requires Mac OS X 10.7 or newer.
    To install on Leopard or Snow Leopard:
      brew tap homebrew/versions
      brew install povray36
    EOS
  end
end

class Povray < Formula
  homepage 'http://www.povray.org/'
  url 'http://www.povray.org/beta/source/povray-3.7.0.RC6.tar.gz'
  version '3.7.0.RC6'
  sha256 '374957bdb90fb7be5f36f839b3f04ab0a4340f6e8cf369f658d6592a342803e3'

  depends_on NeedsLion
  depends_on :libpng
  depends_on 'boost'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'openexr' => :optional

  def patches
    {:p0 => [
      "https://trac.macports.org/export/102440/trunk/dports/graphics/povray/files/patch-boost-1.50.diff",
      "https://trac.macports.org/export/102440/trunk/dports/graphics/povray/files/patch-configure-stat.diff",
      "https://trac.macports.org/export/102440/trunk/dports/graphics/povray/files/patch-lseek64.diff",
      "https://trac.macports.org/export/102440/trunk/dports/graphics/povray/files/patch-vfe-uint.diff"
    ]}
  end

  def install

    # while this is RC6, the code still says RC5, so update to reflect that
    inreplace [ 'VERSION', 'configure' ], '3.7.0.RC5', '3.7.0.RC6'

    # include the boost system library to resolve compilation conflicts
    ENV["LIBS"] = "-lboost_system-mt -lboost_thread-mt"

    args = [
      "COMPILED_BY=homebrew",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--mandir=#{man}",
    ]

    args << "--with-openexr=${HOMEBREW_PREFIX}" if build.include? "use-openexr"

    system "./configure", *args
    system "make install"
  end

  test do
    ohai "Rendering all test scenes; this may take a while"
    system "#{share}/povray-3.7/scripts/allscene.sh", "-o", "."
  end
end
