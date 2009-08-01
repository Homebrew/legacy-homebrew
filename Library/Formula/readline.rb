require 'brewkit'

class Readline <Formula
  @url='ftp://ftp.cwru.edu/pub/bash/readline-6.0.tar.gz'
  @homepage='http://tiswww.case.edu/php/chet/readline/rltop.html'

  # Brew doesn't do anything with these patches, yet.
  @patches=['ftp://ftp.cwru.edu/pub/bash/readline-6.0-patches/readline60-001',
    'ftp://ftp.cwru.edu/pub/bash/readline-6.0-patches/readline60-002',
    'ftp://ftp.cwru.edu/pub/bash/readline-6.0-patches/readline60-003',
    'ftp://ftp.cwru.edu/pub/bash/readline-6.0-patches/readline60-004']

  def install
    system "./configure --prefix='#{prefix}'"
    system "make"
    system "make install"
  end
end
