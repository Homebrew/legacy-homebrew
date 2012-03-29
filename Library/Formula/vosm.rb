require 'formula'

# LGPL library for 2D statistical models
#
# Features:
# 2D statistical model building, including 2D shape model, 2D texture model and 2D concatenated appearance model
# ND profile ASMs, including traditional 1D profile ASM, newly proposed 2D profile ASM
# Local texture contrained (LTC) ASMs, here, only direct LTC-ASM is implemented
# Numerical solution to AAM, including basic AAM, etc.
# Analytical solutions to AAM, including inverse compositional image alignment(ICIA) AAM, and inverse additive image alignment (IAIA) AAM

class Vosm < Formula
  homepage 'http://www.visionopen.com/resources/computer-vision/statistical-models/'
  url 'http://downloads.sourceforge.net/project/vosm/vosm-0.3.2/vosm-0.3.2.tar.bz2'
  md5 '56dce9f67e462c60e60e3d9486ea1e4c'

  depends_on 'cmake' => :build
  depends_on 'opencv'
  depends_on 'boost'

  def install
    
    # More modern versions of boost-filesystem cannot take 
    # boost::filesystem::native as a second argument

    inreplace 'modules/utils/src/VO_ScanFilesInDir.cpp' do |s|
      s.gsub! /,\s*native/, ''
    end

    # The current CMakeLists.txt across the program do not 
    # use the multithreaded libraries, nor do they include boost-system

    inreplace Dir['**/CMakeLists.txt'] do |s|
      s.gsub! /boost_regex/, 'boost_regex-mt'
      s.gsub! /boost_filesystem/, 'boost_filesystem-mt boost_system-mt'
    end

    # Cannot build dynamic libraries at the moment!
    # This is acknowledged by the original developer: see
    # http://www.visionopen.com/forum/computer-vision-group3/vosm-vosm-explorer-forum5/build-vosm-in-vs2010-thread6.0/#postid-34

    system "cmake -D BUILD_SHARED_LIBS=OFF -D CMAKE_INSTALL_PREFIX:PATH=#{prefix} ."
    system "make install"
  end

  def test
    system "vo_smfitting"
  end
end
