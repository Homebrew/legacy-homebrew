class Racket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "http://racket-lang.org/"
  url "http://mirror.racket-lang.org/installers/6.3/racket-minimal-6.3-src-builtpkgs.tgz"
  version "6.3"
  sha256 "72d79026e1301ee222089fb555b3eb7290b95f4b7541fec21b4ddb5842fff081"

  bottle do
    sha256 "a37d51fb235adfe4b796335e56eb6b826b9967ed6a75c996360997865cdabd49" => :el_capitan
    sha256 "0ab11d912b82ab21b53990b94c8e9d55c28d3a5d6c4c58335f29e78aa937c7c5" => :yosemite
    sha256 "474e72aee9d5e4a3b122caac9fe5429da912050bc9353f8c3a8687c4ff232b0d" => :mavericks
  end

  # these two files are amended when (un)installing packages
  skip_clean "lib/racket/launchers.rktd", "lib/racket/mans.rktd"

  def install
    cd "src" do
      args = %W[
        --disable-debug
        --disable-dependency-tracking
        --enable-macprefix
        --prefix=#{prefix}
        --man=#{man}
        --sysconfdir=#{etc}
      ]

      args << "--disable-mac64" unless MacOS.prefer_64_bit?

      system "./configure", *args
      system "make"
      system "make", "install"
    end

    # configure racket's package tool (raco) to do the Right Thing
    # see: http://docs.racket-lang.org/raco/config-file.html
    inreplace etc/"racket/config.rktd" do |s|
        s.gsub!(
            /\(bin-dir\s+\.\s+"#{Regexp.quote(bin)}"\)/,
            "(bin-dir . \"#{HOMEBREW_PREFIX}/bin\")",
        )
        s.gsub!(
            /\n\)$/,
            "\n      (default-scope . \"installation\")\n)",
        )
    end
  end

  def caveats; <<-EOS.undent
    This is a minimal Racket distribution.
    If you want to use the DrRacket IDE, you may run
      raco pkg install --auto drracket
    EOS
  end

  test do
    output = shell_output("#{bin}/racket -e '(displayln \"Hello Homebrew\")'")
    assert_match /Hello Homebrew/, output

    # show that the config file isn't malformed
    output = shell_output("'#{bin}/raco' pkg config")
    assert $?.success?
    assert_match Regexp.new(<<-EOS.undent), output
      ^name:
        #{version}
      catalogs:
        http://download.racket-lang.org/releases/#{version}/catalog/
        http://pkgs.racket-lang.org
        http://planet-compats.racket-lang.org
      default-scope:
        installation
    EOS
  end
end
