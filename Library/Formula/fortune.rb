class Fortune < Formula
  desc "Infamous electronic fortune-cookie generator"
  homepage "http://ftp.ibiblio.org/pub/linux/games/amusements/fortune/!INDEX.html"
  url "http://ftp.ibiblio.org/pub/linux/games/amusements/fortune/fortune-mod-9708.tar.gz"
  sha256 "1a98a6fd42ef23c8aec9e4a368afb40b6b0ddfb67b5b383ad82a7b78d8e0602a"

  bottle do
    revision 1
    sha256 "dc8c37eb3010db915670bb48e3dfe7a785e2503553cf1ac7b3f7e416c5983468" => :el_capitan
    sha256 "7b3d96921c3c20feed7e2bf180bc9d8634ee0d6fe2d8b438c91f2d524388fa05" => :yosemite
    sha256 "cd124a5664773bf11fa334461a835b508c401dc59462abb99d3d83b430091b2d" => :mavericks
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
