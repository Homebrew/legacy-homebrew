require 'formula'

class Normalize < Formula
  homepage 'http://normalize.nongnu.org/'
  url 'http://savannah.nongnu.org/download/normalize/normalize-0.7.7.tar.gz'
  sha1 '1509ca998703aacc15f6098df58650b3c83980c7'

  option 'without-mad', 'Compile without MP3 support'

  depends_on 'mad' => :recommended

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]
    args << "--without-mad" if build.without? "mad"

    system "./configure", *args
    system "make install"
  end

  def test
    system "#{bin}/normalize"
  end
end
