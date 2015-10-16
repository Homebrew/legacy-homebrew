class Euslisp < Formula
  desc "Integrated programming system for the research on intelligent robots"
  homepage "https://github.com/euslisp/EusLisp"
  url "https://github.com/euslisp/EusLisp/archive/EusLisp-9.15.tar.gz"
  sha256 "74cf37606bd9fcb38ddcd6dcfbbb0989375faa9c18ada3dff6e39d610d966ea9"
  head "https://github.com/euslisp/EusLisp.git"

  depends_on :x11

  def install
    ENV.deparallelize
    ENV.O0

    prefix.install Dir["{contrib,doc,lib,lisp,models}"]

    cd "#{prefix}" do
      ENV["ARCHDIR"] = "Darwin"
      ENV["EUSDIR"] = Dir.pwd
      ENV.prepend_path "PATH", prefix/"Darwin/bin"
      ENV.prepend_path "LD_LIBRARY_PATH", prefix/"Darwin/lib"

      cd "lisp" do
        ln_s "Makefile.Darwin", "Makefile"
        system "make"

        bin.mkpath
        system "make", "install", "PUBBINDIR=#{bin}"
      end
    end
  end

  def caveats; <<-EOF.undent
    Please add below lines to your shell configuration file. (ex. ~/.bashrc or ~/.zshrc)
    export EUSDIR=#{opt_prefix}
    EOF
  end

  test do
    ENV["EUSDIR"] = opt_prefix
    system "#{bin}/eus", "(exit)"
  end
end
