require 'formula'

class SourceHighlight < Formula
  homepage 'http://www.gnu.org/software/src-highlite/'
  head 'git://git.savannah.gnu.org/src-highlite.git'
  url 'http://ftpmirror.gnu.org/src-highlite/source-highlight-3.1.7.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/src-highlite/source-highlight-3.1.7.tar.gz'
  sha1 '71c637548be71afc3f895b0d8ada1a72a8dab4a0'

  depends_on 'boost'

  depends_on 'autoconf' if build.head?

  def install
    system "autoconf" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{HOMEBREW_PREFIX}"
    system "make install"

    bash_completion.install 'completion/source-highlight'
  end
end
