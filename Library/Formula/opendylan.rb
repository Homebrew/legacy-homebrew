require "formula"

class Opendylan < Formula
  homepage "http://opendylan.org"
  url "http://opendylan.org/downloads/opendylan/2013.2/opendylan-2013.2-sources.tar.bz2"
  sha1 "df614e11c2aec74448602ba51caf5d664534c06e"
  head "https://github.com/dylan-lang/opendylan.git"

  depends_on :macos => :lion
  depends_on :arch => :intel
  depends_on :autoconf
  depends_on :automake
  depends_on "bdw-gc" => "universal"

  resource :bootstrapping_binary do
    url "http://opendylan.org/downloads/opendylan/2013.2/opendylan-2013.2-x86-darwin.tar.bz2"
    sha1 "78faaec910c67356cd4b5ce7101153b6acf01cbe"
  end

  env :std  # do not use Superenv, the source does not like it

  def install
    ENV.deparallelize  # the source does not want to build in parallel
    resource(:bootstrapping_binary).stage do
      ENV.prepend_path "PATH", Pathname.pwd/"bin"
      cd buildpath do
        system "./autogen.sh"
        system "./configure", "--disable-debug",
                              "--disable-dependency-tracking",
                              "--disable-silent-rules",
                              "--prefix=#{ prefix }"
        system "make", "3-stage-bootstrap"
      end
    end

    system "make", "install"
  end

  test do
    # NOTE: these tests were taken from OpenDylan documentation,
    #   consider keeping them synchronized with the documentation.
    #
    # 1. Example from opendylan/README.rst
    #
    # > Once installed, the following command-line will produce a binary in
    # > _build/bin/hello-world in the current working directory:
    # >
    # >   dylan-compiler -build hello-world
    system bin/"dylan-compiler", "-build", "hello-world"
    assert_equal "hello there!\n",
                 `_build/bin/hello-world`
    assert_equal 0, $?.exitstatus

    # 2. Example from
    # opendylan/documentation/getting-started-cli/source/hello-world.rst
    #
    # >   $ make-dylan-app hello-world
    # >   $ cd hello-world
    # >   $ dylan-compiler -build hello-world.lid
    app_name = "hello-world"
    system bin/"make-dylan-app", app_name
    cd app_name do
      system bin/"dylan-compiler", "-build", app_name + ".lid"
    end
    # >   $ _build/bin/hello-world
    # >   Hello, world!
    assert_equal "Hello, world!\n",
                 `#{ app_name }/_build/bin/#{ app_name }`
    assert_equal 0, $?.exitstatus
  end
end
