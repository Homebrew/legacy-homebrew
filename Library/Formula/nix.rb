class Nix < Formula
  desc "The purely functional package manager"
  homepage "https://nixos.org/nix/"
  url "https://nixos.org/releases/nix/nix-1.10/nix-1.10.tar.xz"
  sha256 "5612ca7a549dd1ee20b208123e041aaa95a414a0e8f650ea88c672dc023d10f6"
  head "https://github.com/NixOS/nix.git"

  option "with-bdw-gc", "enable garbage collection in the Nix expression evaluator."

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "bdw-gc" => :optional

  resource "WWW::Curl" do
    url "https://cpan.metacpan.org/authors/id/S/SZ/SZBALINT/WWW-Curl-4.17.tar.gz"
    sha256 "52ffab110e32348d775f241c973eb56f96b08eedbc110d77d257cdb0a24ab7ba"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    resource("WWW::Curl").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "./bootstrap.sh"
    args = %W[--prefix=#{prefix}
              --localstatedir=#{var}
              --with-store-dir=#{var}/nix/store
           ]
    args << "--enable-gc" if build.with? "bdw-gc"
    system "./configure", *args

    ENV.deparallelize do
      system "make", "install"
    end

    elisp.install share/"emacs/site-lisp/nix-mode.el"

    bin.env_script_all_files(libexec/"bin", :PERL5LIB => ENV["PERL5LIB"])
  end

  test do
    ENV["NIX_STATE_DIR"] = testpath/"var/nix"
    mkdir "#{ENV["HOME"]}/.nix-defexpr"
    system bin/"nix-env", "--query", "--available"
  end
end
