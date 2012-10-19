require 'formula'

class X264 < Formula
  homepage 'http://www.videolan.org/developers/x264.html'
  url 'http://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20120812-2245-stable.tar.bz2'
  sha1 '4be913fb12cd5b3628edc68dedb4b6e664eeda0a'
  version 'r2197.4' # brew install -v --HEAD x264 will display the version.

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
    Because libx264 has a rapidly-changing API, formulae that link against
    it should be reinstalled each time you upgrade x264. Examples include:
       avidemux, ffmbc, ffmpeg, gst-plugins-ugly
    EOS
  end
end
