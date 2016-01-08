class Mg < Formula
  desc "Small Emacs-like editor"
  homepage "http://devio.us/~bcallah/mg/"
  url "http://devio.us/~bcallah/mg/mg-20160103.tar.gz"
  sha256 "4abd059ba3e0d59626104a21812ae33a37ee1f6ddaafdb33511f38d21057fae6"

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
