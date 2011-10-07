require 'formula'

class Povray < Formula
  url 'http://www.povray.org/ftp/pub/povray/Official/Unix/povray-3.6.1.tar.bz2'
  homepage 'http://www.povray.org/'
  md5 'b5789bb7eeaed0809c5c82d0efda571d'

  depends_on 'libtiff' => :optional
  depends_on 'jpeg' => :optional

  if MACOS_VERSION == 10.5
    fails_with_llvm "povray fails with 'terminate called after throwing an instance of int'"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "COMPILED_BY=homebrew",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end

  def test
    ohai "Rendering all test scenes; this may take a while"
    mktemp do
      system "#{share}/povray-3.6/scripts/allscene.sh -o ."
    end
  end
end
