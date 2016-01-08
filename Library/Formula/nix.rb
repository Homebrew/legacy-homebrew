class Nix < Formula
  desc "The purely functional package manager"
  homepage "https://nixos.org/nix/"
  url "http://nixos.org/releases/nix/nix-1.10/nix-1.10.tar.xz"
  sha256 "5612ca7a549dd1ee20b208123e041aaa95a414a0e8f650ea88c672dc023d10f6"
  head "https://github.com/NixOS/nix.git"

  option "with-bdw-gc", "enable garbage collection in the Nix expression evaluator."

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "WWW::Curl" => :perl
  depends_on "openssl"
  depends_on "bdw-gc" => :optional

  def install
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

    mkdir elisp
    mv share/"emacs/site-lisp/nix-mode.el", elisp
  end

  test do
    ENV["NIX_STATE_DIR"] = testpath/"var/nix"
    mkdir "#{ENV["HOME"]}/.nix-defexpr"
    system bin/"nix-env", "--query", "--available"
  end
end
