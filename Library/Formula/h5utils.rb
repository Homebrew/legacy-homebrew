require 'formula'

class H5utils < Formula
    url 'http://ab-initio.mit.edu/h5utils/h5utils-1.12.1.tar.gz'
    homepage 'http://ab-initio.mit.edu/wiki/index.php/H5utils'
    sha1 '1bd8ef8c50221da35aafb5424de9b5f177250d2d'

    depends_on 'hdf5'
    depends_on 'libpng'
    depends_on :x11

    def install
        # patch for libpng 1.5 as described by https://github.com/mxcl/homebrew/pull/6944
        inreplace 'writepng.c', 'png_ptr->jmpbuf', 'png_jmpbuf (png_ptr)'
        inreplace 'writepng.c', 'free(info_ptr->palette);', '/* free(info_ptr->palette); */'
        system "./configure", "--disable-debug", "--disable-dependency-tracking",
                              "--prefix=#{prefix}"
        system "make install"
    end
end
