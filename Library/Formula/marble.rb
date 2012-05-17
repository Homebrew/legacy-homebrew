require 'formula'

class Marble < Formula
  homepage 'http://edu.kde.org/marble'
  url 'http://download.kde.org/stable/4.8.3/src/marble-4.8.3.tar.xz'
  md5 '4e9b84a0d29dc5734bc7f11e5855e16e'

  depends_on 'cmake' => :build
  depends_on 'qt'

  def patches
    #Patch to disable architecture forcing (https://git.reviewboard.kde.org/r/104942/)
    "https://gist.github.com/raw/2662935/56cfb27ebc9bee75deabf85bfcaf484112ceef33/gistfile1.txt"
  end

  def install
    system "cmake #{std_cmake_parameters} -DQTONLY=ON"
    system "make install" # if this fails, try separate make/make install steps
  end
end
