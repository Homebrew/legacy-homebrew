class Chordii < Formula
  desc "Text file to music sheet converter"
  homepage "http://www.vromans.org/johan/projects/Chordii/"
  url "https://downloads.sourceforge.net/project/chordii/chordii/4.5/chordii-4.5.1.tar.gz"
  sha256 "16a3fe92a82ca734cb6d08a573e513510acd41d4020a6306ac3769f6af5aa08d"

  bottle do
    cellar :any
    sha256 "5592e19ddb7affade8a918992648c87bb92a83e201e28f8afdae87e3e3ba4c2b" => :yosemite
    sha256 "f828c0158bfa52c9e136c0332ea595e788af14073082847d51bc4c96e6c909ac" => :mavericks
    sha256 "532cb785f263790e7a314df2a276c2ee73de50fe630df8514586d888c0bb6281" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"homebrew.cho").write <<-EOS.undent
      {title:Homebrew}
      {subtitle:I can't write lyrics. Send help}

      [C]Thank [G]You [F]Everyone,
      [C]We couldn't maintain [F]Homebrew without you,
      [G]Here's an appreciative song from us to [C]you.
    EOS

    system bin/"chordii", "--output=#{testpath}/homebrew.ps", "homebrew.cho"
    assert File.exist?("homebrew.ps")
  end
end
