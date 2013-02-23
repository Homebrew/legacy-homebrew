require 'formula'

class Serf < Formula
  homepage 'http://code.google.com/p/serf/'
  url 'http://serf.googlecode.com/files/serf-1.1.1.tar.bz2'
  sha1 '1ec4689ef57e7c28e7371df00d0ccc3e32ef6457'

<<<<<<< HEAD
  def options
    [['--universal', 'Builds a universal binary.']]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
=======
  option :universal

  depends_on :libtool
  depends_on 'sqlite'

  def apr_bin
    superbin or "/usr/bin"
  end

  def install
    ENV.universal_binary if build.universal?
<<<<<<< HEAD
    if MacOS.mountain_lion?
      # Fixes a bad path returned by `apr-1-config --cpp` on ML.
      # https://github.com/mxcl/homebrew/issues/13586
      ENV['CPP'] = "#{ENV.cc} -E"
      # Use HB libtool not the one from apr that also has a bad path.
      ENV['APR_LIBTOOL'] = 'glibtool'
      # Especially for Xcode-only, the apr hearders are needed by glibtool
      ENV.append 'CPPFLAGS', "-I#{MacOS.sdk_path}/usr/include/apr-1"
    end
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
=======
>>>>>>> 82a1481f6fa824816bbf2bdeb53fd1933a1a15f2
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-apr=#{apr_bin}"
    system "make install"
  end
end
