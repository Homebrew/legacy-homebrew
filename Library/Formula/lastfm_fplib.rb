require 'formula'

class LastfmFplib < Formula
  homepage 'http://blog.last.fm/2007/08/29/audio-fingerprinting-for-clean-metadata'
  head 'svn://svn.audioscrobbler.net/recommendation/MusicID/lastfm_fplib'

  depends_on 'cmake' => :build
  depends_on 'taglib'
  depends_on 'mad'
  depends_on 'libsamplerate'
  depends_on 'fftw'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
