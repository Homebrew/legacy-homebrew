require 'formula'

class Mplayer <Formula
  @homepage='http://www.mplayerhq.hu/'
  @head='svn://svn.mplayerhq.hu/mplayer/trunk'
  
  depends_on 'pkg-config' => :recommended

  def install
    ENV.gcc_4_2   # llvm chokes on labels within mlp inline asm
    system "./configure --prefix='#{prefix}'"
    system "make"
    system "make install"
  end
end