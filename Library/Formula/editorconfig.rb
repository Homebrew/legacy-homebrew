require 'formula'

class Editorconfig < Formula
  homepage 'http://editorconfig.org'
  url 'https://downloads.sourceforge.net/project/editorconfig/EditorConfig-C-Core/0.12.0/source/editorconfig-core-c-0.12.0.tar.gz'
  sha1 'dfa96da823133fd925e7384f19d7f2acf44f50ba'

  depends_on 'cmake' => :build
  depends_on 'pcre'

  head 'https://github.com/editorconfig/editorconfig-core-c.git', :branch => 'master'

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/editorconfig", "--version"
  end
end
