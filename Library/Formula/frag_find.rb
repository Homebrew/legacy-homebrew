require 'formula'

class FragFind < Formula
  homepage 'https://github.com/simsong/frag_find'
  url 'http://digitalcorpora.org/downloads/frag_find/frag_find-1.0.0.tar.gz'
  sha1 '253347cd55196c9f268e0e63825cc2406437977c'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/frag_find"
  end
end
