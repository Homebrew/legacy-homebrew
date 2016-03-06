class Racket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/6.4/racket-minimal-6.4-src-builtpkgs.tgz"
  version "6.4"
  sha256 "cf717d4983f4198fce8973ead5d427bc9da78b73bd51fee16b58c894c2a146e8"

  bottle do
    revision 2
    sha256 "f7b55fde0d4b967b4c9617b47d81a971826ff91cebbae415d681ffeb7c8df7a9" => :el_capitan
    sha256 "5d2b3406f75501379c50c6506c9c817bfadadf236ddb106ced5be9d69d513af0" => :yosemite
    sha256 "fd5d32d41b49e06c0a74669ad64239ccb76c8eb73c99d0d9300f18119ae76886" => :mavericks
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
    # see: https://docs.racket-lang.org/raco/config-file.html
    inreplace etc/"racket/config.rktd" do |s|
        s.gsub!(
            /\(bin-dir\s+\.\s+"#{Regexp.quote(bin)}"\)/,
            "(bin-dir . \"#{HOMEBREW_PREFIX}/bin\")"
        )
        s.gsub!(
            /\n\)$/,
            "\n      (default-scope . \"installation\")\n)"
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
        https://download.racket-lang.org/releases/#{version}/catalog/
        https://pkgs.racket-lang.org
        https://planet-compats.racket-lang.org
      default-scope:
        installation
    EOS
  end
end
