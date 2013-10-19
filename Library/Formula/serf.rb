require 'formula'

class Serf < Formula
  homepage 'http://code.google.com/p/serf/'
  url 'http://serf.googlecode.com/files/serf-1.3.2.tar.bz2'
  sha1 '90478cd60d4349c07326cb9c5b720438cf9a1b5d'

  bottle do
    revision 1
    sha1 '' => :mountain_lion
    sha1 '' => :lion
    sha1 '' => :snow_leopard
  end

  option :universal

  depends_on :libtool
  depends_on 'sqlite'
  depends_on 'scons' => :build

  def install
    # SConstruct merges in gssapi linkflags using scons's MergeFlags,
    # but that discards duplicate values - including the duplicate
    # values we want, like multiple -arch values for a universal build.
    # Passing 0 as the `unique` kwarg turns this behaviour off.
    inreplace 'SConstruct', 'unique=1', 'unique=0'

    ENV.universal_binary if build.universal?
    # scons ignores our compiler and flags unless explicitly passed
    args = %W[PREFIX=#{prefix} GSSAPI=/usr CC=#{ENV.cc}
              CFLAGS=#{ENV.cflags} LINKFLAGS=#{ENV.ldflags}]
    system "scons", *args
    system "scons install"
  end
end
