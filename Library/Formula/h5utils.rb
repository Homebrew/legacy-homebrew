require 'formula'

class H5utils < Formula
  url 'http://ab-initio.mit.edu/h5utils/h5utils-1.12.1.tar.gz'
  homepage 'http://ab-initio.mit.edu/wiki/index.php/H5utils'
  md5 '46a6869fee6e6bf87fbba9ab8a99930e'

  depends_on 'hdf5'

  def install
    ENV.x11 # enable libpng support
    # patch for libpng 1.5 as described by https://github.com/mxcl/homebrew/pull/6944
    inreplace 'writepng.c', 'png_ptr->jmpbuf', 'png_jmpbuf (png_ptr)'
    inreplace 'writepng.c', 'free(info_ptr->palette);', '/* free(info_ptr->palette); */'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end