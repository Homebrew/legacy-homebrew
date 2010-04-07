require 'formula'

class RubyEnterpriseEdition <Formula
  url 'http://rubyforge.org/frs/download.php/68719/ruby-enterprise-1.8.7-2010.01.tar.gz'
  md5 '587aaea02c86ddbb87394a340a25e554'
  homepage 'http://rubyenterpriseedition.com/'

  depends_on 'readline'

  skip_clean 'bin/ruby'

  aka :ree

  def install
    ENV.gcc_4_2 # fails with LLVM
    args = ['./installer', "--auto", prefix, '--no-tcmalloc']
    args << '-c' << '--enable-shared' if ARGV.include?('--enable-shared')
    system *args
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
