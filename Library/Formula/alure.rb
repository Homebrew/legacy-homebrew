require 'formula'

class Alure < Formula
  homepage 'http://kcat.strangesoft.net/alure.html'
  url 'http://kcat.strangesoft.net/alure-releases/alure-1.2.tar.bz2'
  sha1 'f033f0820c449ebff7b4b0254a7b1f26c0ba485b'

  depends_on 'cmake' => :build
  depends_on 'flac'       => :optional
  depends_on 'fluid-synth' => :optional
  depends_on 'libogg'     => :optional
  depends_on 'libsndfile' => :optional
  depends_on 'libvorbis'  => :optional
  depends_on 'mpg123'     => :optional

  def install
    # fix a broken include flags line, which fixes a build error.
    # Not reported upstream.
    # https://github.com/mxcl/homebrew/pull/6368
    inreplace 'CMakeLists.txt', '${VORBISFILE_CFLAGS}',
                                %x[pkg-config --cflags vorbisfile].chomp

    cd "build" do
      system "cmake", "..", *std_cmake_args
      system "make install"
    end
  end
end
