class Idcomments < Formula
  homepage "https://tools.ietf.org/tools/idcomments/"
  url "https://tools.ietf.org/tools/idcomments/idcomments-0.18.tgz"
  sha256 "a75774495e1b9b799326f3c6875db927835546b82762d565efe17e3cbfa6c7b8"

  depends_on "rfcdiff"

  def install
    inreplace "idcomments", "$(tempfile)", "$(mktemp /tmp/idcomments.XXXXXXXX)"
    bin.install "idcomments"
    doc.install %w[about changelog copyright todo]
  end

  test do
    (testpath/"draft").write <<-EOS.undent
      COMMENT: brew
    EOS

    assert_equal "INTRODUCTION, paragraph 0:\n\n\n  brew",
      shell_output("#{bin}/idcomments draft").strip
  end
end
