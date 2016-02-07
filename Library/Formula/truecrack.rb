class Truecrack < Formula
  desc "Brute-force password cracker for TrueCrypt"
  homepage "https://github.com/lvaccaro/truecrack"
  url "https://truecrack.googlecode.com/files/truecrack_v35.tar.gz"
  version "3.5"
  sha256 "25bf270fa3bc3591c3d795e5a4b0842f6581f76c0b5d17c0aef260246fe726b3"

  bottle do
    cellar :any
    sha256 "f89b74c141f59211a8e77f9d09288f3e5bfa8452074ddd41154bf54d4380146b" => :mavericks
    sha256 "17be4dcefbf2274f24ced0b3772632ae67df962db59685fbf2f95aeb48b9fbcf" => :mountain_lion
    sha256 "3f07f5450ab1106604b09d63ae32275bc55e42bc881aba5f1145023e91ad81e5" => :lion
  end

  # Fix missing return value compilation issue
  # https://github.com/lvaccaro/truecrack/issues/41
  patch do
    url "https://gist.githubusercontent.com/anonymous/b912a1ede06eb1e8eb38/raw/1394a8a6bedb7caae8ee034f512f76a99fe55976/truecrack-return-value-fix.patch"
    sha256 "8aa608054f9b822a1fb7294a5087410f347ba632bbd4b46002aada76c289ed77"
  end

  def install
    # Re datarootdir override: Dumps two files in top-level share
    # (autogen.sh and cudalt.py) which could cause conflict elsewhere.
    system "./configure", "--enable-cpu",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--datarootdir=#{pkgshare}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/truecrack"
  end
end
