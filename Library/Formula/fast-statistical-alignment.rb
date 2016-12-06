require 'formula'

class FastStatisticalAlignment < Formula
  homepage 'http://fsa.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/fsa/fsa-1.15.7.tar.gz'
  sha1 '322c8270d027b573b0781d8729f0917206e9d775'

  fails_with :clang do
    build 412
    cause <<-EOS.undent
      In file included from ../../src/annealing/dotplot.h:14:
      ../../src/util/array2d.h:258:82: error: member reference base type 'array2d_type *const' (aka 'array2d<value_type, xy_container_type> *const') is not a
            structure or union
            Column_iterator end() const { return Column_iterator (_array, _col, _array.rows()); }
      EOS
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
