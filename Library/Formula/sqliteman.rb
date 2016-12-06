require 'formula'

class Sqliteman < Formula
  homepage 'http://www.sqliteman.com/'
  url 'http://sourceforge.net/projects/sqliteman/files/sqliteman/1.2.2/sqliteman-1.2.2.tar.bz2'
  sha1 '8ca90d44ad0eda9e67bdd675523a8786b8ef3818'

  depends_on 'cmake' => :build

  depends_on 'qt'
  depends_on 'qscintilla2'

  def install
    # help cmake to find QScintilla include directory
    qsci_include = Formula.factory('qscintilla2').include
    args = std_cmake_args << "-DQSCINTILLA_INCLUDE_DIR=#{qsci_include}/Qsci"

    args << '..'
    mkdir 'macbuild' do
      system 'cmake', *args
      system 'make'
      system 'make', 'install'
    end
  end

  def test
    system "sqliteman"
  end
end
