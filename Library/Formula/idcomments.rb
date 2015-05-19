class Idcomments < Formula
  desc "Extract comments from an internet-draft"
  homepage "https://tools.ietf.org/tools/idcomments/"
  url "https://tools.ietf.org/tools/idcomments/idcomments-0.18.tgz"
  sha256 "a75774495e1b9b799326f3c6875db927835546b82762d565efe17e3cbfa6c7b8"

  bottle do
    cellar :any
    sha256 "d88751b05061809da43a70cb82c517dd82daae2d094d8d349e42f81a672c2667" => :yosemite
    sha256 "08f39fa9183cbae296859a932539f5b1d90a1e68ee0c2b59f1f22809c78fd78d" => :mavericks
    sha256 "f803cad790a7224fc20b2ba843683bb4687af58c21a08c96f23b0710c982af31" => :mountain_lion
  end

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
