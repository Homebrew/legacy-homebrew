require 'formula'

class Editorconfig < Formula
  homepage 'http://editorconfig.org'
  url 'https://downloads.sourceforge.net/project/editorconfig/EditorConfig-C-Core/0.11.5/source/editorconfig-core-c-0.11.5.tar.gz'
  sha1 '2fe9df54d49c17d7e62c3996f4095afcd79d4d28'

  depends_on 'cmake' => :build

  head 'https://github.com/editorconfig/editorconfig-core-c.git', :branch => 'master'

  def install
    system "cmake", ".", "-DCMAKE_INSTALL_PREFIX:PATH=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/editorconfig"
  end
end
