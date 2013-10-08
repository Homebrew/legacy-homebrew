require 'formula'

class Axel < Formula
  homepage 'http://freshmeat.net/projects/axel/'
  url 'http://alioth.debian.org/frs/download.php/file/3016/axel-2.4.tar.bz2'
  sha1 '9e212e2890a678ccb2ab48f575a659a32d07b1a9'

  # New features patches: https://gist.github.com/denji/6652068
  option "with-unicode-progressbar", "Build with unicode characters progress bar."
  option "with-reactivation", "Build with reactivated dynamic segmentation download."
  option "with-no-clobber", "Build with patch support option skip already downloaded."
  # option "with-cookies", "Build with cookies better support for axel."
  option "with-content-disposition", "Build with Recognize Content-disposition."

  def patches
    result = Hash.new { |hash, key| hash[key] = [] }
    if build.with? 'unicode-progressbar'
      result[:p1] << 'https://gist.github.com/denji/6652068/raw/a85a3288b715c04958a2d9e9c0014afbeb0086e1/unicode-progressbar.patch'
    end
    if build.with? 'reactivation'
      result[:p1] << 'https://gist.github.com/denji/6652068/raw/657279e4706eb0257b7c9da053f3862e6ddaef88/reactivation.patch'
    end
    if build.with? 'no-clobber'
      result[:p1] << 'https://gist.github.com/denji/6652068/raw/4aace6ea245b8231f7c84638ac0d2c48c1ef04e9/no-clobber.patch'
    end
    if build.with? 'content-disposition'
      result[:p1] << 'https://gist.github.com/denji/6652068/raw/32b8d64331b08e1b6284c352d1a421aae73f0afb/content-disposition.patch'
    end
    result
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--debug=0", "--i18n=0"
    system "make"
    system "make install"
  end
end
