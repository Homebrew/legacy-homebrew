require "formula"

class Shmcat < Formula
  desc "Tool that dumps shared memory segments (System V and POSIX)"
  homepage "http://shmcat.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/shmcat/shmcat-1.7.tar.bz2"
  sha1 "30f6bc931859e1544e783edc84f137e9c4a0b5f6"

  option "with-ftok", "Build the ftok utility"
  option "with-nls", "Use Native Language Support"

  depends_on "gettext" if build.with? "nls"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]
    args << "--disable-ftok" if build.without? "ftok"
    if build.with? "nls"
      gettext = Formula["gettext"]
      args << "--with-libintl-prefix=#{gettext.include}"
    else
      args << "--disable-nls"
    end

    system "./configure", *args
    system "make install"
  end
end
