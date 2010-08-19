require 'formula'

class GooglePerftools <Formula
  url 'http://google-perftools.googlecode.com/files/google-perftools-1.5.tar.gz'
  homepage 'http://code.google.com/p/google-perftools/'
  md5 'cab3841f23fb93f8c69aedf60afcc43f'

  def install
    ENV.append_to_cflags '-D_XOPEN_SOURCE'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
