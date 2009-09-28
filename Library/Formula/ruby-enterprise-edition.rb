require 'brewkit'

class RubyEnterpriseEdition <Formula
  url 'http://rubyforge.org/frs/download.php/64475/ruby-enterprise-1.8.7-20090928.tar.gz'
  md5 'ae00018ce89d95419dfde370fcd485ac'
  homepage 'http://rubyenterpriseedition.com/'

  def install
    ENV.gcc_4_2 # fails with LLVM
    system "./installer --auto #{prefix} --no-tcmalloc"
  end
end
