require 'formula'

class Tmux <Formula
  url 'http://downloads.sourceforge.net/tmux/tmux-1.2.tar.gz'
  md5 '748fbe7bb5f86812e19bd6005ff21a5a'
  homepage 'http://tmux.sourceforge.net'

  depends_on 'libevent'

  def install
    ENV['PREFIX'] = "#{prefix}"
    system "./configure"

    inreplace "GNUmakefile" do |f|
      # Fix 'install' flags
      f.gsub! " -g bin -o root", ""
      # Put docs in the right place
      f.gsub! "man/man1", "share/man/man1"
    end

    system "make install"
  end
end
