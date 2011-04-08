require 'formula'

class X264 < Formula
  url "http://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20100903-2245.tar.bz2"
  homepage 'http://www.videolan.org/developers/x264.html'
  md5 '79d13e0fd56a73c65f75940d70e9c450'
  version 'r1713M-c276662'

  head 'git://git.videolan.org/x264.git'

  depends_on 'yasm' => :build

  def install
    # Having this set can fail the endian test!
    ENV['GREP_OPTIONS'] = ''
    system "./version.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared"

    inreplace 'config.mak' do |s|
      ldflags = s.get_make_var 'LDFLAGS'
      s.change_make_var! 'LDFLAGS', ldflags.gsub!(' -s', '')

      if MacOS.prefer_64_bit?
        soflags = s.get_make_var 'SOFLAGS'
        s.change_make_var! 'SOFLAGS', soflags.gsub!(' -Wl,-read_only_relocs,suppress', '')
      end
    end

    system "make install"
  end
end
