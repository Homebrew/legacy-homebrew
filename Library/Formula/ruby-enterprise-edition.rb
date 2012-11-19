require 'formula'

class RubyEnterpriseEdition < Formula
  homepage 'http://rubyenterpriseedition.com/'
  url 'http://rubyenterpriseedition.googlecode.com/files/ruby-enterprise-1.8.7-2011.03.tar.gz'
  sha1 '662f37afbe04f3a55ac3b119227a2cd4e53745bf'

  env :std

  option 'enable-shared', "Compile shared, but see caveats"

  depends_on 'readline'

  fails_with :llvm

  def install
    readline = Formula.factory('readline').prefix

    args = ["--auto", prefix, '--no-tcmalloc']
    args << '-c' << '--enable-shared' if build.include? 'enable-shared'
    # Configure will complain that this is an unknown option, but it is actually OK
    args << '-c' << "--with-readline-dir=#{readline}"
    system './installer', *args
  end

  def caveats; <<-EOS.undent
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
