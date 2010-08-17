require 'formula'

class Botan <Formula
  url 'http://botan.randombit.net/files/Botan-1.8.8.tbz'
  homepage 'http://botan.randombit.net/'
  md5 'cb7cf79c34414cdf1f7a25569d7b82ac'

  def install
    inreplace 'src/build-data/makefile/unix_shr.in' do |s|
      s.change_make_var! 'SONAME', "#{lib}/$(LIBNAME)-$(SO_VERSION).%{so_suffix}"
    end

    system "./configure.py", "--prefix=#{prefix}"
    system "make install"
  end
end
