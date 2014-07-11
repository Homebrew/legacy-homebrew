require 'formula'

class Kytea < Formula
  homepage 'http://www.phontron.com/kytea/'

  stable do
    url 'http://www.phontron.com/kytea/download/kytea-0.4.6.tar.gz'
    sha1 '2fb22c64a7babff26d95874877d83a9ef1f09617'

    # Upstream patch to fix compilation on OS X
    patch :p1 do
      url "https://github.com/neubig/kytea/commit/782553f61bde4f3366f946c9a390500c028fa17f.diff"
      sha1 "260d62738e53622873b1d467b44576860e5141fe"
    end
  end

  head do
    url 'https://github.com/neubig/kytea.git', :branch => 'master'
    depends_on 'autoconf' => :build
    depends_on 'automake' => :build
    depends_on 'libtool' => :build
  end

  def install
    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
