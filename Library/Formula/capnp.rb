require 'formula'

class Capnp < Formula
  homepage 'http://kentonv.github.io/capnproto/'
  url 'http://capnproto.org/capnproto-c++-0.3.0.tar.gz'
  sha1 '26152010298db40687bf1b18ff6a438986289a44'

  resource 'clang' do
    # "As of this writing, Mac OSX 10.8 with Xcode 4.6 command-line tools is not quite good enough to compile Cap’n Proto. The included version of GCC is ancient. The included version of Clang – which mysteriously advertises itself as version 4.2 – was actually cut from LLVM SVN somewhere between versions 3.1 and 3.2; it is not sufficient to build Cap’n Proto."
    # http://kentonv.github.io/capnproto/install.html
    # Old formula worked on ML test-bot reports, so I'm guessing this is only for older Xcode installations
    url 'http://llvm.org/releases/3.2/clang+llvm-3.2-x86_64-apple-darwin11.tar.gz'
    sha1 'ae98cce94e335cb409edab95f0b7170af6c0278b'
  end unless MacOS.clang_version.to_f >= 5.0

  def install
    args = ["--disable-debug", "--disable-dependency-tracking", "--disable-silent-rules", "--prefix=#{prefix}"]
    unless MacOS.clang_version.to_f >= 5.0
      resource('clang').stage do
        system "ln", "-s",
               "/usr/lib/c++", "lib/c++"
        clang_dir = pwd
        args << "CXX=#{clang_dir}/bin/clang++"
      end
    end
    system "./configure", *args
    system "make", "-j6", "check"
    system "make", "install"
  end

  test do
    system "capnp", "--version"
  end
end
