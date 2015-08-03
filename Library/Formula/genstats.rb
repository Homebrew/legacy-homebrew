class Genstats < Formula
  desc "Generate statistics about stdin or textfiles"
  homepage "http://www.vanheusden.com/genstats/"
  url "http://www.vanheusden.com/genstats/genstats-1.2.tgz"
  sha256 "f0fb9f29750cdaa85dba648709110c0bc80988dd6a98dd18a53169473aaa6ad3"

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
