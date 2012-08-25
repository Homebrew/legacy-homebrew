require 'formula'

class Ctail < Formula
  homepage 'http://ctail.i-want-a-pony.com/'
  url 'http://ctail.i-want-a-pony.com/downloads/ctail-0.1.0.tar.bz2'
  sha1 '4bd0373df88136b48cac721c98d34cefda27aff9'

  depends_on :automake
  depends_on :libtool

  def install
    if MacOS.mountain_lion?
      # Fixes a bad path returned by `apr-1-config --cpp` on ML.
      # https://github.com/mxcl/homebrew/issues/13586
      ENV['CPP'] = "#{ENV.cc} -E"
      # Use HB libtool not the one from apr that also has a bad path.
      ENV['APR_LIBTOOL'] = 'glibtool'
      # Especially for Xcode-only, the apr hearders are needed by glibtool
      ENV.append 'CPPFLAGS', "-I#{MacOS.sdk_path}/usr/include/apr-1"
    end

    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system 'make'
    system 'make install'
  end
end
