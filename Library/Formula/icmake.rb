class Icmake < Formula
  desc "Make utility using a C-line grammar"
  homepage "https://fbb-git.github.io/icmake/"
  url "https://github.com/fbb-git/icmake/archive/7.23.02.tar.gz"
  sha256 "f030086d0630c2c1755519556b9cf88b8495bc8debf36b257e0c69d3b199c46b"
  revision 1

  bottle do
    sha256 "a8d78a2d192e97d98abc4c02b6ef4411ea47f17056591f44c3bc755bd695fecb" => :el_capitan
    sha256 "cbc0de675413c996b4988fe061c2c15b774ea63cd230fc363858ae3e0e04c089" => :yosemite
    sha256 "8e25ce4cb2d564ef4ed938b69b1b0566520383dd9d754af77a4271ab6281784e" => :mavericks
  end

  depends_on "gnu-sed"

  def install
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin"

    # override the existing file
    (buildpath/"icmake/INSTALL.im").open("w") do |f|
      f.write <<-EOS.undent
        #define BINDIR      "#{bin}"
        #define SKELDIR     "#{pkgshare}"
        #define MANDIR      "#{man}"
        // not a typo; the install script puts binaries under LIBDIR/
        #define LIBDIR      "#{bin}"
        #define CONFDIR     "#{etc}"
        #define DOCDIR      "#{doc}"
        #define DOCDOCDIR   "#{doc}"
      EOS
    end

    cd "icmake" do
      system "./icm_bootstrap", "/"
      system "./icm_install", "all", "/"
    end
  end

  test do
    (testpath/"script.im").write <<-EOS.undent
      string TEST;

      void main() {
        TEST = "foobar";
      }
    EOS
    system "#{bin}/icmake", "script.im", (testpath/"test")
  end
end
