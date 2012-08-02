require 'formula'

class Serf < Formula
  homepage 'http://code.google.com/p/serf/'
  url 'http://serf.googlecode.com/files/serf-1.1.0.tar.bz2'
  sha1 '231af70b7567a753b49df4216743010c193884b7'

  depends_on :automake
  depends_on :libtool

  def options
    [['--universal', 'Builds a universal binary.']]
  end

  def install
    ENV.universal_binary if ARGV.build_universal?
    if MacOS.mountain_lion?
      # Fixes a bad path returned by `apr-1-config --cpp` on ML.
      # https://github.com/mxcl/homebrew/issues/13586
      ENV['CPP'] = "#{ENV.cc} -E"
      # Use HB libtool not the one from apr that also has a bad path.
      ENV['APR_LIBTOOL'] = 'glibtool'
    end
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
