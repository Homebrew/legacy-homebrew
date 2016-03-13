class TranslateShell < Formula
  desc "Command-line translator using Google Translate and more"
  homepage "https://www.soimort.org/translate-shell"
  url "https://github.com/soimort/translate-shell/archive/v0.9.3.2.tar.gz"
  sha256 "4ddf7292802f6d81a8e9c736a3ff854ebcc193866e9774376dc0c2f8d893323a"
  head "https://github.com/soimort/translate-shell.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8623a978baf2ac631125f1eacb5f5d28492a8bab08bede0c454b4d27e52c847" => :el_capitan
    sha256 "caec9cbcdc3590f1af1e668b3da4e26ff4782a9698f4e03f42a9fe42d0de0f1d" => :yosemite
    sha256 "7057ee2ec32e7aae09b55b652f3c6f7b89375c89debcf0d338ee319c133faa96" => :mavericks
  end

  depends_on "fribidi"
  depends_on "gawk"
  depends_on "rlwrap"

  def install
    system "make"
    bin.install "build/trans"
    man1.install "man/trans.1"
  end

  def caveats; <<-EOS.undent
    By default, text-to-speech functionality is provided by OS X's builtin
    `say' command. This functionality may be improved in certain cases by
    installing one of mplayer, mpv, or mpg123, all of which are available
    through `brew install'.
    EOS
  end

  test do
    assert_equal "Hello\n", shell_output("#{bin}/trans -no-init -b -s fr -t en bonjour")
  end
end
