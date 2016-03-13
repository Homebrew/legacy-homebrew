class TranslateShell < Formula
  desc "Command-line translator using Google Translate and more"
  homepage "https://www.soimort.org/translate-shell"
  url "https://github.com/soimort/translate-shell/archive/v0.9.3.2.tar.gz"
  sha256 "4ddf7292802f6d81a8e9c736a3ff854ebcc193866e9774376dc0c2f8d893323a"
  head "https://github.com/soimort/translate-shell.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "854dbbeda540c28d188184d4d286807e6d3d645159bc0972d350cbbe9a723184" => :el_capitan
    sha256 "3211d41aea77077a19a773f4d8f8ec65b8dc365b684df1036eebd57f753b1149" => :yosemite
    sha256 "4eec43b9052180d05df5b0be9fa9ca57891d85a354baf7c608b52a5282d504e0" => :mavericks
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
