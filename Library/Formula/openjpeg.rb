require 'formula'

class Openjpeg < Formula
  homepage 'http://www.openjpeg.org/'
  url 'http://openjpeg.googlecode.com/files/openjpeg_v1_4_sources_r697.tgz'
  version '1.4'
  md5 '7870bb84e810dec63fcf3b712ebb93db'

  head 'http://openjpeg.googlecode.com/svn/trunk/'

  # Head can have an optional dep on little-cms2 for which there is a pull request,
  # but it's unlikely to be pulled as there is a policy against multiple versions.
  # If the user adds little-cms2 themselves, installing head will find and use it,
  # without any changes to the formula.
  depends_on 'cmake' => :build
  depends_on 'libtiff'
  depends_on 'little-cms' => :optional

  def install

    # Fixes missing symbols, as Apple removed zlib.h from png.h on Lion.
    if MacOS.lion? and not ARGV.build_head?
      inreplace 'codec/convert.c', '#include <png.h>',
                                   "#include <png.h>\n#include <zlib.h>"
    end

    Dir.mkdir 'macbuild'
    Dir.chdir 'macbuild' do
      system "cmake #{std_cmake_parameters} .."
      system "make install"
    end
  end
end
