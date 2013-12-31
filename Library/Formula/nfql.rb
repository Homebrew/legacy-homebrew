require 'formula'

class Nfql < Formula
  homepage 'https://github.com/vbajpai/nfql'
  url 'https://github.com/vbajpai/nfql/releases/download/v0.7.1/nfql-0.7.1.tar.gz'
  sha1 'e230bc502db10168d32c5607dd097194fdb5d835'

  depends_on 'cmake' => :build
  depends_on 'flow-tools'
  depends_on 'libfixbuf'
  depends_on 'gettext'
  depends_on 'homebrew/versions/json-c010'

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/'nfql', '--version'
  end
end
