require 'formula'

class RubyEnterpriseEdition <Formula
  url 'http://rubyforge.org/frs/download.php/66162/ruby-enterprise-1.8.7-2009.10.tar.gz'
  md5 '3727eef7b6b1b2f31db7d091328d966e'
  homepage 'http://rubyenterpriseedition.com/'

  skip_clean 'bin/ruby'

  aka :ree

  def install
    ENV.gcc_4_2 # fails with LLVM
    system "./installer --auto #{prefix} --no-tcmalloc"
  end
end
