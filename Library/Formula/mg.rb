class Mg < Formula
  desc "Small Emacs-like editor"
  homepage "https://devio.us/~bcallah/mg/"
  url "https://devio.us/~bcallah/mg/mg-20160103.tar.gz"
  sha256 "4abd059ba3e0d59626104a21812ae33a37ee1f6ddaafdb33511f38d21057fae6"

  bottle do
    cellar :any_skip_relocation
    sha256 "54e088aa608c93e2c78ae0a6d7e838e5364998b10163ca360ef014818c383c0e" => :el_capitan
    sha256 "26f35442ecd13cd1de86b530998251da80f72b2854ed1ae28c8f0eec436adaa0" => :yosemite
    sha256 "6a2e606dce9970e35b767739b66f76c5174e3bb0f7ce2e09d4d683fdbe077525" => :mavericks
  end

  conflicts_with "mg3a", :because => "both install `mg` binaries"

  def install
    system "make", "install", "PREFIX=#{prefix}", "MANDIR=#{man}"
  end

  test do
    (testpath/"command.sh").write <<-EOS.undent
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/mg
      match_max 100000
      send -- "\u0018\u0003"
      expect eof
    EOS
    chmod 0755, testpath/"command.sh"

    system testpath/"command.sh"
  end
end
