require 'formula'

class Io <Formula
  head 'git://github.com/stevedekorte/io.git'
  homepage 'http://iolanguage.com/'

  depends_on 'cmake'
  depends_on 'libsgml'

  def install
    ENV.j1
    FileUtils.mkdir 'io-build'

    Dir.chdir 'io-build' do
      system "cmake .. #{std_cmake_parameters}"
      system "make install"
    end

    FileUtils.rm_f Dir['docs/*.pdf']
    doc.install Dir['docs/*']
  end
end
