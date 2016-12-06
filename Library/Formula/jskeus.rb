class Jskeus < Formula
  desc "EusLisp software developed and used by JSK at The University of Tokyo."
  homepage "https://github.com/euslisp/jskeus"
  url "https://github.com/euslisp/jskeus/archive/1.0.10.tar.gz"
  version "1.0.10"
  sha256 "038d394438dff837b9268dbec48063b33532669d5786201e2e67433fade371f1"
  head "https://github.com/euslisp/jskeus.git"

  depends_on :x11
  depends_on "euslisp"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "mesalib-glw"
  depends_on "wget" => :build

  def install
    ENV.deparallelize
    ENV.O0

    prefix.install "Makefile", Dir["{doc,images,irteus}"]

    cd "#{prefix}" do
      ln_s Formula["euslisp"].prefix, "#{Dir.pwd}/eus"
      system "make", "irteus-installed"

      bin.install "eus/Darwin/bin/eusg"
      bin.install "eus/Darwin/bin/eusgl"
      bin.install "eus/Darwin/bin/irteusgl"
    end
  end

  def caveats; <<-EOF
    Please add below in your shell configuration file. (ex. ~/.bashrc or ~/.zshrc)
    export EUSDIR=#{prefix}/eus
    export ARCHDIR=Darwin
    export LD_LIBRARY_PATH=$EUSDIR/$ARCHDIR/bin:$LD_LIBRARY_PATH
    EOF
  end

  test do
    ENV["EUSDIR"] = Formula["euslisp"].opt_prefix
    system "#{bin}/irteusgl", "(exit)"
  end
end
