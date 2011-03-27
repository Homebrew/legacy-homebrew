require 'formula'

class X264 < Formula
  url 'http://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20110326-2245-stable.tar.bz2'
  homepage 'http://www.videolan.org/developers/x264.html'
  md5 '114327ff055670084bdf301a1a7da86a'
  version 'r1924M'

  head 'git://git.videolan.org/x264.git'

  depends_on 'yasm' => :build

  def install
    # Having this set can fail the endian test!
    ENV['GREP_OPTIONS'] = ''
    system "./version.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "--disable-debug"

    inreplace 'config.mak' do |s|
      ldflags = s.get_make_var 'LDFLAGS'
      s.change_make_var! 'LDFLAGS', ldflags.gsub!(' -s', '')

      if MacOS.prefer_64_bit?
        soflags = s.get_make_var 'SOFLAGS'
        s.change_make_var! 'SOFLAGS', soflags.gsub!(' -Wl,-read_only_relocs,suppress', '')
      end
    end

    system "make install"

    if Formula.factory('ffmpeg').installed?
      ohai 'It is recommended that your re-install ffmpeg after updating x264.'
      ohai 'A simple \'brew install ffmpeg\' will work.'
    end

  end
end
