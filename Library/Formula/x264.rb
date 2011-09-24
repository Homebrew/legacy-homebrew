require 'formula'

class X264 < Formula
  url 'http://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20110912-2245-stable.tar.bz2'
  homepage 'http://www.videolan.org/developers/x264.html'
  md5 '08b1658cf9964b73a53f445e4d21e161'
  version 'r2066'

  head 'git://git.videolan.org/x264.git'

  depends_on 'yasm' => :build

  def install
    # Having this set can fail the endian test!
    ENV['GREP_OPTIONS'] = ''
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared"

    if MacOS.prefer_64_bit?
      inreplace 'config.mak' do |s|
        soflags = s.get_make_var 'SOFLAGS'
        s.change_make_var! 'SOFLAGS', soflags.gsub(' -Wl,-read_only_relocs,suppress', '')
      end
    end

    system "make install"
  end
end
