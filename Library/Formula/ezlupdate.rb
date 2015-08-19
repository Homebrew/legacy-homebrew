class Ezlupdate < Formula
  desc "Create .ts files for eZ publish"
  homepage "http://ezpedia.org/ez/ezlupdate"
  url "https://github.com/ezsystems/ezpublish-legacy/archive/v2015.01.2.tar.gz"
  sha256 "17ce825bc4b85a1c84f7d23b1f8ff0099c0272038be360aca243dda112514f6c"

  head "https://github.com/ezsystems/ezpublish-legacy.git"

  bottle do
    cellar :any
    sha256 "e806bb39c4d4753e82bd03d9cbcfe08b3299b0c07a7f89a58b8287c4bb82f753" => :yosemite
    sha256 "15da172b1bd18f7dc2db82ffec7866cfa7fdc8b8cb11113d025bb5af4a335835" => :mavericks
    sha256 "4d5a6ce1f59247f3f7e2973653f70477f8abd8d95e496644aa90d888477f8b44" => :mountain_lion
  end

  depends_on "qt"

  def install
    cd "support/ezlupdate-qt4.5/ezlupdate" do
      # Use the qmake installation done with brew
      # because others installations can make a mess
      system "#{HOMEBREW_PREFIX}/bin/qmake", "ezlupdate.pro"
      system "make"
    end
    bin.install "bin/macosx/ezlupdate"
  end

  test do
    (testpath/"share/translation").mkpath
    system "#{bin}/ezlupdate", "-v", "eng-GB"
  end
end
