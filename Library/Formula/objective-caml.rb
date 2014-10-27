require "formula"

class ObjectiveCaml < Formula
  homepage "http://ocaml.org"
  url "http://caml.inria.fr/pub/distrib/ocaml-4.02/ocaml-4.02.1.tar.gz"
  sha1 "6af8c67f2badece81d8e1d1ce70568a16e42313e"

  head "http://caml.inria.fr/svn/ocaml/trunk", :using => :svn
  revision 1

  option 'without-x11', 'Install without the Graphics module'
  depends_on :x11 => :optional

  bottle do
    revision 5
    sha1 "1d63e6eff490aeb5e53a29e44473d2564ba2cab4" => :yosemite
    sha1 "63727401bb4bbb8b16dc29631c2efaed6499a655" => :mavericks
    sha1 "4f74b7cb5dd3cd4560cb42249a3de109f09fb597" => :mountain_lion
  end

  def install
    args = %W[
      --prefix #{HOMEBREW_PREFIX}
      --mandir #{man}
      -cc #{ENV.cc}
      -with-debug-runtime
    ]
    args << "-aspp" << "#{ENV.cc} -c"
    args << "-no-graph" if build.without?("x11")

    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores
    system "./configure", *args
    system "make world"
    system "make opt"
    system "make opt.opt"
    system "make", "PREFIX=#{prefix}", "install"
    (lib/"ocaml/site-lib").mkpath
  end

  def post_install
    # site-lib in the Cellar will be a symlink to the HOMEBREW_PREFIX location,
    # which is mkpath'd by Keg#link when something installs into it
    (lib/"ocaml").install_symlink HOMEBREW_PREFIX/"lib/ocaml/site-lib"
  end
end
