require 'formula'

class Sqliteman < Formula
  homepage 'http://www.sqliteman.com/'
  url 'http://sourceforge.net/projects/sqliteman/files/sqliteman/1.2.2/sqliteman-1.2.2.tar.bz2'
  sha1 '8ca90d44ad0eda9e67bdd675523a8786b8ef3818'

  depends_on 'cmake' => :build

  depends_on 'qt'
  depends_on 'qscintilla2'

  def install
    mkdir 'build' do
      qsci_include = Formula.factory('qscintilla2').include
      qsci_cmake_arg = "-DQSCINTILLA_INCLUDE_DIR=#{qsci_include}/Qsci"
      system 'cmake', '..', qsci_cmake_arg, *std_cmake_args
      system 'make'
      system 'make', 'install'
    end
  end

  def test
    system "#{bin}/sqliteman", '--langs'
  end
end
