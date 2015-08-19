class Pev < Formula
  desc "PE analysis toolkit"
  homepage "http://pev.sf.net/"
  url "https://downloads.sourceforge.net/project/pev/pev-0.70/pev-0.70.tar.gz"
  sha256 "250396a06930d60a92e9bc86d7afb543d899ba12c007d1be5d09802a02908202"

  head "https://github.com/merces/pev.git"

  depends_on "pcre"

  def install
    inreplace "src/Makefile" do |s|
      s.gsub! "/usr", prefix
      s.change_make_var! "SHAREDIR", share
      s.change_make_var! "MANDIR", man
    end

    inreplace "lib/libpe/Makefile" do |s|
      s.gsub! "/usr", prefix
    end

    system "make", "CC=#{ENV.cc}"
    system "make", "install"
  end

  test do
    system "#{bin}/pedis", "--version"
  end
end
