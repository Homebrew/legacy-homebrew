require "formula"

class ObjectiveCaml < Formula
  homepage "http://ocaml.org"
  url "http://caml.inria.fr/pub/distrib/ocaml-4.02/ocaml-4.02.1.tar.gz"
  sha1 "6af8c67f2badece81d8e1d1ce70568a16e42313e"
  revision 1

  head "http://caml.inria.fr/svn/ocaml/trunk", :using => :svn

  option 'without-camlp4', 'Install without camlp4'
  option 'without-x11', 'Install without the Graphics module'
  depends_on :x11 => :optional

  resource "camlp4" do
    url "https://github.com/ocaml/camlp4/archive/4.02.1+1.tar.gz"
    sha1 "7d0f879517887299167f1c3eefa8f4d266d69183"
  end

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

    resource('camlp4').stage do
      # TODO: attempt to set the PATH to the Cellar-installed compiler.
      # This currently fails since the compiler is a bytecode executable
      # that expects to find ocamlrun in the `HOMEBREW_PREFIX` and not
      # `prefix`.  It would be far easier to depend on an installed OCaml.
      ENV.prepend_path "PATH", bin
      # TODO: OCAMLLIB overrides the location of the standard library
      # from the HOMEBREW_PREFIX to the Cellar location.
      ENV["OCAMLLIB"] = "#{prefix}/lib/ocaml"
      system "./configure", "--bindir=#{bin}",
                            "--libdir=#{HOMEBREW_PREFIX}/lib/ocaml",
                            "--pkgdir=#{HOMEBREW_PREFIX}/lib/ocaml/camlp4"
      system "make all"
      system "make install"
    end if build.with? 'camlp4'

  end

  def post_install
    # site-lib in the Cellar will be a symlink to the HOMEBREW_PREFIX location,
    # which is mkpath'd by Keg#link when something installs into it
    (lib/"ocaml").install_symlink HOMEBREW_PREFIX/"lib/ocaml/site-lib"
  end
end
