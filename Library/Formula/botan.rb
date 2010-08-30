require 'formula'

class Botan <Formula
  url 'http://botan.randombit.net/files/Botan-1.8.9.tbz'
  homepage 'http://botan.randombit.net/'
  md5 '2c1c55ae4f5bae9f6ad516e1ada2100f'

  def install
    inreplace 'src/build-data/makefile/unix_shr.in' do |s|
      s.change_make_var! 'SONAME', "#{lib}/$(LIBNAME)-$(SO_VERSION).%{so_suffix}"
    end

    system "./configure.py", "--prefix=#{prefix}"
    system "make install"
  end
end
