require 'formula'

def use_gmp?
  ARGV.include? '--with-gmp'
end

def use_readline?
  ARGV.include? '--with-readline'
end

class Pari < Formula
  url 'http://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.5.0.tar.gz'
  homepage 'http://pari.math.u-bordeaux.fr/'
  md5 '0b595a1345679ff482785a686c863e9f'

  depends_on 'readline' if use_readline?
  depends_on 'gmp' if use_gmp?

  def options
    [
      ['--with-readline', 'Build with GNU readline support.'],
      ['--with-gmp', 'Build wth GNU MP support.']
    ]
  end

  def install
    ENV.x11
    readline = Formula.factory 'readline'
    gmp = Formula.factory 'gmp'

    args = ["--prefix=#{prefix}"]
    args << "--with-readline=#{readline.prefix}" if use_readline?
    args << "--with-gmp=#{gmp.prefix}" if use_gmp?

    system "./Configure", *args
    system "make gp"
    system "make install"
  end
end
