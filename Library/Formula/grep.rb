require 'formula'

class Grep <Formula
  homepage 'http://www.gnu.org/software/grep/'
  url 'http://ftp.gnu.org/gnu/grep/grep-2.7.tar.gz'
  md5 'e848f07e3e79aa7899345d17c7e4115e'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-nls",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}"

    # Configure gives me no -liconv, so fix that
    inreplace "src/Makefile" do |s|
      s.change_make_var! "LIBS", "-liconv -lpcre"
    end

    system "make install"
  end
end
