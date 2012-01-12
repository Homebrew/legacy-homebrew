require 'formula'

class X264 < Formula
  url 'http://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20111115-2245-stable.tar.bz2'
  homepage 'http://www.videolan.org/developers/x264.html'
  md5 '062491c2dce5349c3c32b82103428033'
  version 'r2092'

  head 'git://git.videolan.org/x264.git'

  depends_on 'yasm' => :build

  def options
    [["--10-bit", "Make a 10-bit x264. (default: 8-bit)"]]
  end

  def install
    # Having this set can fail the endian test!
    ENV['GREP_OPTIONS'] = ''

    args = ["--prefix=#{prefix}", "--enable-shared"]
    args << "--bit-depth=10" if ARGV.include?('--10-bit')

    system "./configure", *args

    if MacOS.prefer_64_bit?
      inreplace 'config.mak' do |s|
        soflags = s.get_make_var 'SOFLAGS'
        s.change_make_var! 'SOFLAGS', soflags.gsub(' -Wl,-read_only_relocs,suppress', '')
      end
    end

    system "make install"
  end
end
