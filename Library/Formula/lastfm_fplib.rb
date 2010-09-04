require 'formula'

class LastfmFplib <Formula
  head 'svn://svn.audioscrobbler.net/recommendation/MusicID/lastfm_fplib'
  homepage 'http://blog.last.fm/2007/08/29/audio-fingerprinting-for-clean-metadata'

  depends_on 'cmake'
  depends_on 'taglib'
  depends_on 'mad'
  depends_on 'libsamplerate'
  depends_on 'fftw'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
