require 'formula'

def without_geometry?
  ARGV.include? '--without-geometry'
end

def without_numerics?
  ARGV.include? '--without-numerics'
end

def without_imaging?
  ARGV.include? '--without-imaging'
end

def without_video?
  ARGV.include? '--without-video'
end

def without_probability?
  ARGV.include? '--without-probability'
end

def without_serialisation?
  ARGV.include? '--without-serialisation'
end

def without_utilities?
  ARGV.include? '--without-utilities'
end

def without_contrib?
  ARGV.include? '--without-contrib'
end

def with_testing?
  ARGV.include? '--with-testing'
end

def with_examples?
  ARGV.include? '--with-examples'
end

class Vxl <Formula
  url 'http://sourceforge.net/projects/vxl/files/vxl/1.14/vxl-1.14.0.zip'
  homepage 'http://vxl.sourceforge.net/'
  md5 '0329521f2fda61d2835e7b3c7c1189df'
  version '1.14.0'

  depends_on 'cmake'

  def options
    [
      ['--without-geometry',      'Do not build geometry libraries'],
      ['--without-numerics',      'Do not build numerics libraries'],
      ['--without-imaging',       'Do not build imaging libraries'],
      ['--without-video',         'Do not build video libraries'],
      ['--without-probability',   'Do not build probability libraries'],
      ['--without-serialisation', 'Do not build serialisation libraries'],
      ['--without-utilities',     'Do not build utilities'],
      ['--without-contrib',       'Do not build contributed libraries'],
      ['--with-testing',          'Build testing (not recommended)'],
      ['--with-examples',         'Build examples (not recommended)'],
    ]
  end

  def install
    args = [""];
    args << " -D BUILD_CORE_GEOMETRY:BOOL=OFF "      if without_geometry?
    args << " -D BUILD_CORE_NUMERICS:BOOL=OFF "      if without_numerics?
    args << " -D BUILD_CORE_IMAGING:BOOL=OFF "       if without_imaging?
    args << " -D BUILD_CORE_VIDEO:BOOL=OFF "         if without_video?
    args << " -D BUILD_CORE_PROBABILITY:BOOL=OFF "   if without_probability?
    args << " -D BUILD_CORE_SERIALISATION:BOOL=OFF " if without_serialisation?
    args << " -D BUILD_CORE_UTILITIES:BOOL=OFF "     if without_utilities?
    args << " -D BUILD_CONTRIB:BOOL=OFF "            if without_contrib?
    args << " -D BUILD_TESTING:BOOL=OFF "            unless with_testing?
    args << " -D BUILD_EXAMPLES:BOOL=OFF "           unless with_examples?

    args << " #{std_cmake_parameters} . "

    system "cmake #{args}"
    system "make install"
  end
end
