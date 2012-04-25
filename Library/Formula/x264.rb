require 'formula'

class X264 < Formula
  homepage 'http://www.videolan.org/developers/x264.html'
  # The version is _not_ 2245. See http://www.x264.nl/x264/changelog.txt for
  # the revision numbers that are attached to each commit.
  url 'http://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20120425-2245-stable.tar.bz2'
  sha1 '969e015e5df24091b5e62873808e6529a7f2fb7f'
  version 'r2184'

  head 'git://git.videolan.org/x264.git'

  depends_on 'yasm' => :build

  def options
    [["--10-bit", "Make a 10-bit x264. (default: 8-bit)"]]
  end

  def install
    ENV.O1 if ENV.compiler == :clang  # See issue 11248
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
