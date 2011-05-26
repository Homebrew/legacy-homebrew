require 'formula'

class Unac < Formula
  url 'http://download.savannah.gnu.org/releases/unac/unac-1.7.0.tar.gz'
  homepage 'http://savannah.nongnu.org/projects/unac/'
  md5 '884d057e644d3f26ec503b0780fbcb2b'

  def patches
    "https://gist.github.com/raw/992290/34b3ad99904001efc509ab72c5b1478d25a0dd0a/a.patch"
  end

  def install
    ENV.append 'LDFLAGS', '-liconv'
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end