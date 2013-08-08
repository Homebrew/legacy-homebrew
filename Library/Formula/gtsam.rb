require 'formula'

class Gtsam < Formula
  homepage 'https://collab.cc.gatech.edu/borg/gtsam/'
  url 'https://research.cc.gatech.edu/borg/sites/edu.borg/files/downloads/gtsam-2.3.0.tgz'
  sha1 'ec1a3e8a91365a9680ba92349705b37c98555e7c'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    mkdir 'build' do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
