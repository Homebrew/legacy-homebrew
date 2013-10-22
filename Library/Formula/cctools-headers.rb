require 'formula'

# The system versions are too old to build ld64
class CctoolsHeaders < Formula
  homepage 'http://opensource.apple.com/'
  url 'http://www.opensource.apple.com/tarballs/cctools/cctools-836.tar.gz'
  sha1 'fe2aab3f527adf6c775462ac045699a150dc7f82'

  keg_only :provided_by_osx

  resource 'headers' do
    url 'http://opensource.apple.com/tarballs/xnu/xnu-2050.18.24.tar.gz'
    sha1 '3a2a0b3629cb215b17aca3bb365b8b10b8b408fe'
  end

  def install
    # only supports DSTROOT, not PREFIX
    inreplace "include/Makefile", "/usr/include", "/include"
    system "make", "installhdrs", "DSTROOT=#{prefix}", "RC_ProjectSourceVersion=#{version}"
    # installs some headers we don't need to DSTROOT/usr/local/include
    (prefix/'usr').rmtree

    # ld64 requires an updated mach/machine.h to build
    resource('headers').stage {(include/'mach').install 'osfmk/mach/machine.h'}
  end
end
