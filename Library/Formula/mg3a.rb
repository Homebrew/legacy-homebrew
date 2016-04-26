class Mg3a < Formula
  desc "Small Emacs-like editor inspired like mg with UTF8 support"
  homepage "http://www.bengtl.net/files/mg3a/"
  url "http://www.bengtl.net/files/mg3a/mg3a.160323.tar.gz"
  sha256 "627dff8cd6c9c8c14d2e28e7fec4ac164e061a29bbca229bb46a69f9259f0db3"

  bottle do
    cellar :any_skip_relocation
    sha256 "a652e2b3196d2c9588aa7329240557f0c53c21ad59f7784e6d484d714e5e5907" => :el_capitan
    sha256 "333e6ecefb626b705fb669ab829435f2755caf1542e8247263b19b497f6f75e1" => :yosemite
    sha256 "0955d93c265511831b39e14a2dcd8efca2c0e692abb8a3f502858123830dd447" => :mavericks
  end

  conflicts_with "mg", :because => "both install `mg`"

  option "with-c-mode", "Include the original C mode"
  option "with-clike-mode", "Include the C mode that also handles Perl and Java"
  option "with-python-mode", "Include the Python mode"
  option "with-most", "Include c-like and python modes, user modes and user macros"
  option "with-all", "Include all fancy stuff"

  def install
    if build.with?("all")
      mg3aopts = "-DALL" if build.with?("all")
    else
      mg3aopts = %w[-DDIRED -DPREFIXREGION -DUSER_MODES -DUSER_MACROS]
      mg3aopts << "-DLANGMODE_C" if build.with?("c-mode")
      mg3aopts << "-DLANGMODE_PYTHON" if build.with?("python-mode") || build.with?("most")
      mg3aopts << "-DLANGMODE_CLIKE" if build.with?("clike-mode") || build.with?("most")
    end

    system "make", "CDEFS=#{mg3aopts * " "}", "LIBS=-lncurses", "COPT=-O3"
    bin.install "mg"
    doc.install Dir["bl/dot.*"]
    doc.install Dir["README*"]
  end

  test do
    (testpath/"command.sh").write <<-EOS.undent
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/mg
      match_max 100000
      send -- "\u0018\u0003"
      expect eof
    EOS
    (testpath/"command.sh").chmod 0755

    system testpath/"command.sh"
  end
end
