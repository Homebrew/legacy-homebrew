class Tpp < Formula
  desc "Ncurses-based presentation tool"
  homepage "https://synflood.at/tpp.html"
  url "https://synflood.at/tpp/tpp-1.3.1.tar.gz"
  sha256 "68e3de94fbfb62bd91a6d635581bcf8671a306fffe615d00294d388ad91e1b5f"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0b802dc4116de3774ec49c334cfc3857812abe01dd1925d2c0a2c0a10313bd8" => :el_capitan
    sha256 "4f22f55329a54c477c0f2dbc795be1aa7711e7c11b0c941d6a1c72d511ad94e5" => :yosemite
    sha256 "7b84619c71138a698f5fb04b1e431f999c2b2d08626fa8fdfdc2a5f4c1202196" => :mavericks
  end

  depends_on "figlet" => :optional

  resource "ncurses-ruby" do
    url "https://downloads.sf.net/project/ncurses-ruby.berlios/ncurses-ruby-1.3.1.tar.bz2"
    sha256 "dca8ce452e989ce1399cb683184919850f2baf79e6af9d16a7eed6a9ab776ec5"
  end

  def install
    lib_ncurses = libexec+"ncurses-ruby"
    inreplace "tpp.rb", 'require "ncurses"', <<-EOS.undent
      require File.expand_path('#{lib_ncurses}/ncurses_bin.bundle', __FILE__)
      require File.expand_path('#{lib_ncurses}/ncurses_sugar.rb', __FILE__)
    EOS

    bin.install "tpp.rb" => "tpp"
    share.install "contrib", "examples"
    man1.install "doc/tpp.1"
    doc.install "README", "CHANGES", "DESIGN", "COPYING", "THANKS", "README.de"

    resource("ncurses-ruby").stage do
      inreplace "extconf.rb", '$CFLAGS  += " -g"',
                              '$CFLAGS  += " -g -DNCURSES_OPAQUE=0"'
      system "ruby", "extconf.rb"
      system "make"
      lib_ncurses.install "lib/ncurses_sugar.rb", "ncurses_bin.bundle"
    end
  end

  test do
    assert_equal "tpp - text presentation program #{version}",
                 shell_output("#{bin}/tpp --version", 1).chomp
  end
end
