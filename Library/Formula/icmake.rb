class Icmake < Formula
  desc "Make utility using a C-line grammar"
  homepage "https://fbb-git.github.io/icmake/"
  url "https://github.com/fbb-git/icmake/archive/7.23.02.tar.gz"
  sha256 "f030086d0630c2c1755519556b9cf88b8495bc8debf36b257e0c69d3b199c46b"
  revision 1

  bottle do
    sha256 "49ab9282e271c7ef224d96bc8275ee514c947db502776875214836d26adca07e" => :el_capitan
    sha256 "a3c2bb91444af1316fea3bece3998b43b668617b1718d9565059c844d073ecb1" => :yosemite
    sha256 "14f7c58f5b4704762da013b6daf811f38c68a57400c3a4c00d89460a571f0a4b" => :mavericks
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
