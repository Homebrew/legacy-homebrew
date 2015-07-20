class Kroman < Formula
  desc "Covert Korean Hangul to Romannized Syllables"
  homepage "https://github.com/cheunghy/kroman"
  url "https://github.com/cheunghy/kroman/archive/v1.0.zip"
  sha1 "1b14683829a62e61b500ab0263bac814b48cf850"
  head "https://github.com/cheunghy/kroman.git"

  def install
    system "make kroman"
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    system "#{bin}/kroman", "--version"
  end
end
