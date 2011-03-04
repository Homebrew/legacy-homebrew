require 'formula'

class E2fsprogs <Formula
  url 'http://downloads.sourceforge.net/project/e2fsprogs/e2fsprogs/1.41.12/e2fsprogs-1.41.12.tar.gz'
  homepage 'http://e2fsprogs.sourceforge.net/'
  md5 '1b24a21fc0c2381ef420961cbfec733f'

  keg_only "This brew installs several commands which override OS X-provided file system commands."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
