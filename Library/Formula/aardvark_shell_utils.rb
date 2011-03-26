require 'formula'

class AardvarkShellUtils < Formula
  url 'http://downloads.laffeycomputer.com/current_builds/shellutils/aardvark_shell_utils-1.0.tar.gz'
  homepage 'http://www.laffeycomputer.com/shellutils.html'
  md5 '2e3a3bb99a07e82b44237daf23de4626'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
