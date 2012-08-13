require 'formula'

class X264 < Formula
  homepage 'http://www.videolan.org/developers/x264.html'
  url 'http://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20120609-2245-stable.tar.bz2'
  sha1 '9abf3129cf4ebdf4409164a9334f52aad935bdd2'
  version 'r2197' # brew install -v --HEAD x264 will display the version.

  head 'http://git.videolan.org/git/x264.git', :branch => 'stable'

  depends_on 'yasm' => :build

  option '10-bit', 'Build a 10-bit x264 (default: 8-bit)'

  def install
    if build.head?
      ENV['GIT_DIR'] = cached_download/'.git'
      system './version.sh'
    end
    args = ["--prefix=#{prefix}", "--enable-shared"]
    args << "--bit-depth=10" if build.include? '10-bit'

    system "./configure", *args

    if MacOS.prefer_64_bit?
      inreplace 'config.mak' do |s|
        soflags = s.get_make_var 'SOFLAGS'
        s.change_make_var! 'SOFLAGS', soflags.gsub(' -Wl,-read_only_relocs,suppress', '')
      end
    end

    system "make install"
  end

  def caveats; <<-EOS.undent
    Because x264 installs its library with a version number that changes,
    any of these that you have installed should be reinstalled each time you
    upgrade x264.
       avidemux, ffmbc, ffmpeg, gst-plugins-ugly
    EOS
  end
end
