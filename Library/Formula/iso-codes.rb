require 'formula'

class IsoCodes < Formula
  homepage 'http://pkg-isocodes.alioth.debian.org/'
  url 'http://pkg-isocodes.alioth.debian.org/downloads/iso-codes-3.47.tar.xz'
  sha1 'fb09dd07ff2bac215e0be8850868b03403346e79'

  depends_on 'xz' => :build
  depends_on 'gettext' => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
