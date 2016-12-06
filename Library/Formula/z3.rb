require 'formula'

class Z3 < Formula
  homepage 'http://z3.codeplex.com/'
  version '4.3.1'
  url 'http://download-codeplex.sec.s-msft.com/Download/SourceControlFileDownload.ashx?ProjectName=z3&changeSetId=89c1785b73225a1b363c0e485f854613121b70a7'
  sha1 '91726a94a6bc0c1035d978b225f3f034387fdfe0'
  head 'https://git01.codeplex.com/z3', :using => :git

  depends_on :autoconf
  depends_on :automake
  depends_on :python

  def install
    if ENV.compiler == :clang
      onoe <<-EOS.undent
        Z3 currently does not compile with Clang. To install it using gcc run:
          brew install z3 --use-gcc
      EOS
    else
      ENV['CXX'] = 'g++'
    end

    system 'autoconf'
    system './configure', "--prefix=#{prefix}"
    system 'python', 'scripts/mk_make.py'
    cd 'build' do
      system 'make'
      system 'make install'
    end
  end
end
