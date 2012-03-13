require 'formula'

class SharedDesktopOntologies < Formula
  homepage 'http://sourceforge.net/apps/trac/oscaf/'
  url 'http://downloads.sourceforge.net/project/oscaf/shared-desktop-ontologies/0.9/shared-desktop-ontologies-0.9.0.tar.bz2?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Foscaf%2Ffiles%2F&ts=1331464711&use_mirror=superb-dca2'
  md5 '8cd0950dc66eb5fbe560ac7fdb416e04'

  depends_on 'cmake' => :build

  def install
    system "cmake #{std_cmake_parameters} ."
    system "make install"
  end
end
