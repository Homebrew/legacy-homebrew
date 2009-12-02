require 'formula'

class Mplayer <Formula
  @homepage='http://www.mplayerhq.hu/'
  @head='svn://svn.mplayerhq.hu/mplayer/trunk'
  
  depends_on 'pkg-config' => :recommended

  # http://github.com/mxcl/homebrew/issues/#issue/87
  depends_on :subversion if MACOS_VERSION < 10.6

  def install
    ENV.gcc_4_2   # llvm chokes on labels within mlp inline asm
    system "./configure --prefix='#{prefix}'"
    system "make"
    system "make install"
  end
end