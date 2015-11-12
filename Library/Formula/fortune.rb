class Fortune < Formula
  desc "Infamous electronic fortune-cookie generator"
  homepage "http://ftp.ibiblio.org/pub/linux/games/amusements/fortune/!INDEX.html"
  url "http://ftp.ibiblio.org/pub/linux/games/amusements/fortune/fortune-mod-9708.tar.gz"
  sha256 "1a98a6fd42ef23c8aec9e4a368afb40b6b0ddfb67b5b383ad82a7b78d8e0602a"

  bottle do
    sha256 "6ccf821f74aca9c1d6f79573b4243911f81d8a1ddfbc1082e27ee7e7c1178549" => :el_capitan
    sha256 "bfae1a94a0de8d9d53f28b5cfdea3b04190420dde0b83c862d6ef536c03d59ef" => :yosemite
    sha256 "90e758b8875a309116e89f475d7c88da5e7e1417601705eb45abf20a5be11a8a" => :mavericks
    sha256 "25958474483a88a12bf8585f21864d190179547271527af8c292bd7ecf6d5677" => :mountain_lion
  end

  option "without-offensive", "Don't install potentially offensive fortune files"

  deprecated_option "no-offensive" => "without-offensive"

  def install
    ENV.deparallelize

    inreplace "Makefile" do |s|
      # Use our selected compiler
      s.change_make_var! "CC", ENV.cc

      # Change these first two folders to the correct location in /usr/local...
      s.change_make_var! "FORTDIR", "/usr/local/bin"
      s.gsub! "/usr/local/man", "/usr/local/share/man"
      # Now change all /usr/local at once to the prefix
      s.gsub! "/usr/local", prefix

      # OS X only supports POSIX regexes
      s.change_make_var! "REGEXDEFS", "-DHAVE_REGEX_H -DPOSIX_REGEX"
      # Don't install offensive fortunes
      s.change_make_var! "OFFENSIVE", "0" if build.include? "no-offensive"
    end

    system "make", "install"
  end

  test do
    system "#{bin}/fortune"
  end
end
