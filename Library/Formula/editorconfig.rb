require 'formula'

class Editorconfig < Formula
  homepage 'http://editorconfig.org'
  url 'https://downloads.sourceforge.net/project/editorconfig/EditorConfig-C-Core/0.12.0/source/editorconfig-core-c-0.12.0.tar.gz'
  sha1 'dfa96da823133fd925e7384f19d7f2acf44f50ba'

  bottle do
    cellar :any
    sha1 "9ecacf9c908945bcda00206afa77d1871b5f2f72" => :mavericks
    sha1 "1b2365c812d65888725763d7dd4ec9cf7bb6c924" => :mountain_lion
    sha1 "84b22980c00b6c779f6308561b06058f5e3d5b11" => :lion
  end

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
