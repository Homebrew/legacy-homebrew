class When < Formula
  desc "Tiny personal calendar"
  homepage "http://www.lightandmatter.com/when/when.html"
  url "https://mirrors.ocf.berkeley.edu/debian/pool/main/w/when/when_1.1.35.orig.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/w/when/when_1.1.35.orig.tar.gz"
  sha256 "f880c0d80b1023a05df99690e36be133c46071657b9921fc9e8d16115fb13ae6"
  head "https://github.com/bcrowell/when.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f533fd4c38cc717e11b9fdf3c8143cd2b58aeafe344b73027e3255151815d135" => :el_capitan
    sha256 "e7033ecfcf3e30fabace03990e56b7acb60bf20c75e46c66ef0af093bb8c029f" => :yosemite
    sha256 "0aece5543b4b9eaf405bfd7527a142975b5e2845b94d8cb2ca9ca4147008b742" => :mavericks
  end

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    (testpath/".when/preferences").write <<-EOS.undent
      calendar = #{testpath}/calendar
    EOS

    (testpath/"calendar").write "2015 April 1, stay off the internet"
    system bin/"when", "i"
  end
end
