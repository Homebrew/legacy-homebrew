class Ssed < Formula
  desc "Super sed stream editor"
  homepage "http://sed.sourceforge.net/grabbag/ssed/"
  url "http://sed.sourceforge.net/grabbag/ssed/sed-3.62.tar.gz"
  sha256 "af7ff67e052efabf3fd07d967161c39db0480adc7c01f5100a1996fec60b8ec4"

  bottle do
    sha256 "7e313ca41f3a8e37bc91ab4a9d8c7acbf508cd7a89ac605df7cee3adcf108510" => :yosemite
    sha256 "448b2fdfee6f84c3d72fdf29d5ccd042027a9850ea16d75b5f4ee576d8cbadcc" => :mavericks
    sha256 "793435451341ea1e475bde0d46745ba233df28c5ed4bd86f7761a2fad3568fba" => :mountain_lion
  end

  conflicts_with "gnu-sed", :because => "both install share/info/sed.info"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--program-prefix=s"
    system "make", "install"
  end

  test do
    assert_equal "homebrew",
      pipe_output("#{bin}/ssed s/neyd/mebr/", "honeydew", 0).chomp
  end
end
