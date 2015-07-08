class StyleCheck < Formula
  desc "Parses latex-formatted text in search of forbidden phrases"
  homepage "https://www.cs.umd.edu/~nspring/software/style-check-readme.html"
  url "https://www.cs.umd.edu/~nspring/software/style-check-0.14.tar.gz"
  sha256 "2ae806fcce9e3b80162c64634422dc32d7f0e6f8a81ba5bc7879358744b4e119"

  def install
    inreplace "style-check.rb", "/etc/style-check.d/", etc/"style-check.d/"
    system "make", "PREFIX=#{prefix}",
                   "SYSCONFDIR=#{etc}/style-check.d",
                   "install"
  end

  test do
    (testpath/".style-censor").write "homebrew % capitalize Homebrew\n"
    (testpath/"paper.tex").write "Today I worked on homebrew\n"

    system "#{bin}/style-check.rb", "-v", "paper.tex"
  end
end
