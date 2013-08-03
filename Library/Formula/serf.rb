require 'formula'

class Serf < Formula
  homepage 'http://code.google.com/p/serf/'
  url 'http://serf.googlecode.com/files/serf-1.2.1.tar.bz2'
  sha1 'f65fbbd72926c8e7cf0dbd4ada03b0d226f461fd'

  option :universal

  depends_on :libtool
  depends_on 'sqlite'

  def apr_bin
    superbin or "/usr/bin"
  end

  def install
    if MacOS.version >= :mountaion_lion
      # Fixes a bad path returned by `apr-1-config --cpp` on ML.
      # https://github.com/mxcl/homebrew/issues/13586
      ENV['CPP'] = "#{ENV.cc} -E"
      # Use HB libtool not the one from apr that also has a bad path.
      ENV['APR_LIBTOOL'] = 'glibtool'
      ENV.append 'CPPFLAGS', "-I#{MacOS.sdk_path}/usr/include/apr-1"
    end

    ENV.universal_binary if build.universal?
    system "./configure", "--prefix=#{prefix}",
                          "--with-apr=#{apr_bin}"
    system "make install"
  end
end
