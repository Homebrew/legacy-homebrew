require 'formula'

class Glimpse < Formula
  homepage 'http://webglimpse.net/'
  url 'http://webglimpse.net/trial/glimpse-latest.tar.gz'
  sha1 '2a935b0bace3f61f756676c8fe28e583a71d048d'

  def install
    ENV.deparallelize

    # didn't report upstream, their bugzilla is not working
    # at http://webglimpse.net/bugzilla/
    inreplace 'Makefile.in', 'mandir = $(prefix)/man/man1',
			'mandir = @mandir@/man/man1'

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make install"
  end

  def test
    system "glimpse --version"
  end
end
