require 'formula'

class Libxapian < Formula
  homepage 'http://xapian.org/'
  url 'http://oligarchy.co.uk/xapian/1.2.12/xapian-core-1.2.12.tar.gz'
  sha1 '2b96800280fee41eed767289620172f5226c9c4f'

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make install"
  end
end
