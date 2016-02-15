class Apparix < Formula
  desc "File system navigation via bookmarking directories"
  homepage "http://micans.org/apparix/"
  url "http://micans.org/apparix/src/apparix-11-062.tar.gz"
  sha256 "211bb5f67b32ba7c3e044a13e4e79eb998ca017538e9f4b06bc92d5953615235"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "89d7d52f9f2e76f1dd6b91075f407fa71000be0b09bd4548c11a6fd820b87ab3" => :el_capitan
    sha256 "9ff5a4568499ba2ca67b7c1bae689ab25576409da76798642b3c4caee489c878" => :yosemite
    sha256 "537fac6c0755ea6ef4ac4a6da2840de49c2c125015afaee6cf691ac33937c380" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    mkdir "test"
    system "#{bin}/apparix", "--add-mark", "homebrew", "test"
    assert_equal "j,homebrew,test",
      shell_output("#{bin}/apparix -lm homebrew").chomp
  end
end
