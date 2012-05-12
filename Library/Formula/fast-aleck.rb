require 'formula'

class FastAleck < Formula
  homepage 'https://github.com/ddfreyne/fast-aleck'
  url 'https://github.com/ddfreyne/fast-aleck/zipball/v0.1.0'
  head 'https://github.com/ddfreyne/fast-aleck.git'
  md5 '2faeb255f8d18d6bcbd1dd67e2a54b6c'

  depends_on 'cmake' => :build

  def install
    mkdir 'build'
    cd 'build' do
      system "cmake .."
      system "make"
      bin.install "fast-aleck"
      lib.install "libfast-aleck.dylib"
    end
  end

  def test
    system "fast-aleck --help"
  end
end
