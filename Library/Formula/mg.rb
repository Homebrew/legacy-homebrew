class Mg < Formula
  desc "Small Emacs-like editor"
  homepage "https://devio.us/~bcallah/mg/"
  url "https://devio.us/~bcallah/mg/mg-20160103.tar.gz"
  sha256 "4abd059ba3e0d59626104a21812ae33a37ee1f6ddaafdb33511f38d21057fae6"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "5ed12a2bdce7b76ff2f336a0dcc1ec1be95cf8194cd253600d6edde4de51ac36" => :el_capitan
    sha256 "1feeace7595726f96687dc2ee0bf2836ac9aaba982d39306f32703047340827d" => :yosemite
    sha256 "f199621c41a7f6af908017610eac17f5d81da652ceeab148560afb96c8ba9ccc" => :mavericks
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
