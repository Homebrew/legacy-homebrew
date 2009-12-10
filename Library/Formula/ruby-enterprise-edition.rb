require 'formula'

class RubyEnterpriseEdition <Formula
  url 'http://rubyforge.org/frs/download.php/66162/ruby-enterprise-1.8.7-2009.10.tar.gz'
  md5 '3727eef7b6b1b2f31db7d091328d966e'
  homepage 'http://rubyenterpriseedition.com/'

  skip_clean 'bin/ruby'

  aka :ree

  def install
    ENV.gcc_4_2 # fails with LLVM
    args = ['./installer', "--auto", prefix, '--no-tcmalloc']
    args.push('-c --enable-shared') if ARGV.include?('--enable-shared')
    system *args
  end

  def caveats; <<-EOS
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
