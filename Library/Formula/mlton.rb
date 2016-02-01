class Mlton < Formula
  desc "Whole-program, optimizing compiler for Standard ML"
  homepage "http://mlton.org"
  url "https://downloads.sourceforge.net/project/mlton/mlton/20130715/mlton-20130715.src.tgz"
  version "20130715"
  sha256 "215857ad11d44f8d94c27f75e74017aa44b2c9703304bcec9e38c20433143d6c"

  depends_on "gmp"

  # The corresponding upstream binary release used to bootstrap.
  resource "bootstrap" do
    url "https://downloads.sourceforge.net/project/mlton/mlton/20130715/mlton-20130715-3.amd64-darwin.gmp-static.tgz"
    sha256 "7e865cd3d1e48ade3de9b7532a31e94af050ee45f38a2bc87b7b2c45ab91e8e1"
  end

  # Configure GMP location via Makefile (https://github.com/MLton/mlton/pull/136)
  patch do
    url "https://github.com/MLton/mlton/commit/6e79342cdcf2e15193d95fcd3a46d164b783aed4.diff"
    sha256 "2d44891eaf3fdecd3b0f6de2bdece463c71c425100fbac2d00196ad159e5c707"
  end

  def install
    # Install the corresponding upstream binary release to 'bootstrap'.
    bootstrap = buildpath/"bootstrap"
    resource("bootstrap").stage do
      args = %W[
        WITH_GMP=#{Formula["gmp"].opt_prefix}
        PREFIX=#{bootstrap}
        MAN_PREFIX_EXTRA=/share
      ]
      system "make", *(args + ["install"])
    end
    ENV.prepend_path "PATH", bootstrap/"bin"

    # Support parallel builds (https://github.com/MLton/mlton/issues/132)
    ENV.deparallelize
    args = %W[
      WITH_GMP=#{Formula["gmp"].opt_prefix}
      DESTDIR=
      PREFIX=#{prefix}
      MAN_PREFIX_EXTRA=/share
    ]
    system "make", *(args + ["all-no-docs"])
    system "make", *(args + ["install-no-docs"])
  end

  test do
    (testpath/"hello.sml").write <<-'EOS'.undent
      val () = print "Hello, Homebrew!\n"
    EOS
    system "#{bin}/mlton", "hello.sml"
    assert_equal "Hello, Homebrew!\n", `./hello`
  end
end
