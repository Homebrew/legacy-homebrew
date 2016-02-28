class Racket < Formula
  desc "Modern programming language in the Lisp/Scheme family"
  homepage "https://racket-lang.org/"
  url "https://mirror.racket-lang.org/installers/6.3/racket-minimal-6.3-src-builtpkgs.tgz"
  version "6.3"
  sha256 "72d79026e1301ee222089fb555b3eb7290b95f4b7541fec21b4ddb5842fff081"

  bottle do
    revision 1
    sha256 "bfa9a6ecd8ec2b61fe58f7f3576471f09c08c1ec404d059a18609bff6728967b" => :el_capitan
    sha256 "dc4b3f00480486eb54a1e86b6c7148cfd14fee1fb3e8cd7f8caa4b8c11436729" => :yosemite
    sha256 "01ebd100e40cdc605d5023da5a608b8a73c4151829bf36806baec71aa126d04a" => :mavericks
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
        http://download.racket-lang.org/releases/#{version}/catalog/
        http://pkgs.racket-lang.org
        http://planet-compats.racket-lang.org
      default-scope:
        installation
    EOS
  end
end
