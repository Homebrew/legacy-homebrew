require 'formula'

class Auctex < Formula
  homepage 'http://www.gnu.org/software/auctex/'
  url 'http://ftpmirror.gnu.org/auctex/auctex-11.87.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/auctex/auctex-11.87.tar.gz'
  sha1 '0be92c7d8f89d57346fe07f05a1a045ffd11cd71'

  head do
    url 'git://git.savannah.gnu.org/auctex.git'
    depends_on "autoconf" => :build
  end

  depends_on :tex

  option "with-emacs=", "Path to an emacs binary"

  def which_emacs
    emacs = ARGV.value('with-emacs') || which('emacs').to_s
    raise "#{emacs} not found" unless File.exist? emacs
    return emacs
  end

  def install
    # configure fails if the texmf dir is not there yet
    brew_texmf = share + 'texmf'
    brew_texmf.mkpath

    system "./autogen.sh" if build.head?

    system "./configure", "--prefix=#{prefix}",
                          "--with-texmf-dir=#{brew_texmf}",
                          "--with-emacs=#{which_emacs}",
                          "--with-lispdir=#{share}/emacs/site-lisp"

    system "make"
    ENV.deparallelize # Needs a serialized install
    system "make install"
  end

  def caveats
    # check if the used emacs is in HOMEBREW_PREFIX/bin
    # for which case HOMEBREW_PREFIX/share/emacs/site-lisp should already
    # be by default in the load-path
    if which_emacs.index("#{HOMEBREW_PREFIX}/bin")
      dot_emacs = <<-EOS
      (require 'tex-site)
      EOS
    else
      dot_emacs = <<-EOS
      (add-to-list 'load-path "#{HOMEBREW_PREFIX}/share/emacs/site-lisp")
      (require 'tex-site)
      EOS
    end

    <<-EOS.undent
    texmf files installed into:
      #{HOMEBREW_PREFIX}/share/texmf/

    You can add it to your TEXMFHOME using:
      sudo tlmgr conf texmf TEXMFHOME "~/Library/texmf:#{HOMEBREW_PREFIX}/share/texmf"

    Emacs package installed into:
      #{HOMEBREW_PREFIX}/share/emacs/site-lisp

    To activate, add the following to your .emacs:
#{dot_emacs}
    EOS
  end
end
