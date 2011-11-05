require 'formula'

class RubyEnterpriseEdition < Formula
  url 'http://rubyenterpriseedition.googlecode.com/files/ruby-enterprise-1.8.7-2011.03.tar.gz'
  md5 '038604ce25349e54363c5df9cd535ec8'
  homepage 'http://rubyenterpriseedition.com/'

  depends_on 'readline'

  fails_with_llvm "fails with LLVM"

  skip_clean 'bin/ruby'

  def options
    [['--enable-shared', "Compile shared, but see caveats."]]
  end

  def install
    readline = Formula.factory('readline').prefix

    args = ['./installer', "--auto", prefix, '--no-tcmalloc']
    args << '-c' << '--enable-shared' if ARGV.include? '--enable-shared'
    # Configure will complain that this is an unknown option, but it is actually OK
    args << '-c' << "--with-readline-dir=#{readline}"
    system *args
  end

  def caveats; <<-EOS.undent
    Consider using RVM or Cinderella to manage Ruby environments:
      * RVM: http://rvm.beginrescueend.com/
      * Cinderella: http://www.atmos.org/cinderella/

    By default we don't compile REE as a shared library. From their documentation:
        Please note that enabling --enable-shared will make the Ruby interpreter
        about 20% slower.

    For desktop environments (particularly ones requiring RubyCocoa) this is
    acceptable and even desirable.

    If you need REE to be compiled as a shared library, you can re-compile like so:
        brew install ruby-enterprise-edition --force --enable-shared
    EOS
  end
end
