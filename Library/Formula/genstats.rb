class Genstats < Formula
  desc "Generate statistics about stdin or textfiles"
  homepage "https://www.vanheusden.com/genstats/"
  url "https://www.vanheusden.com/genstats/genstats-1.2.tgz"
  sha256 "f0fb9f29750cdaa85dba648709110c0bc80988dd6a98dd18a53169473aaa6ad3"

  bottle do
    cellar :any_skip_relocation
    sha256 "44502f7a2dfcb1355336db69267d6363d6e8b8767b47628b0d3099743513ed5f" => :el_capitan
    sha256 "91737ec825ed346716fddcedc4e075b195f214dfb22586a33d46f7ec5ea3a17e" => :yosemite
    sha256 "d46142a806e13029120bfb1a038805b07dc88b191aed1cd41340f5f868168f92" => :mavericks
  end

  depends_on :macos => :lion # uses strndup

  def install
    # Tried to make this a patch.  Applying the patch hunk would
    # fail, even though I used "git diff | pbcopy".  Tried messing
    # with whitespace, # lines, etc.  Ugh.
    inreplace "br.cpp" do |s|
      s.gsub! /if \(_XOPEN_VERSION >= 600\)/, "if (_XOPEN_VERSION >= 600) && !__APPLE__"
    end

    system "make"
    bin.install("genstats")
    man.install("genstats.1")
  end

  test do
    system "#{bin}/genstats -h | grep folkert@vanheusden.com"
  end
end
