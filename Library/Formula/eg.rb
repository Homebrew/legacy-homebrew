class Eg < Formula
  desc "Expert Guide. Norton Guide Reader For GNU/Linux"
  homepage "http://www.davep.org/norton-guides/"
  url "http://www.davep.org/norton-guides/eg-1.00.tar.gz"
  sha256 "e985b2abd160c5f65bea661de800f0a83f0bfbaca54e5cbdc2e738dfbbdb164e"
  head "https://github.com/davep/eg.git"

  stable do
    # Fix unescaped EOLs in static string
    patch do
      url "https://github.com/davep/eg/commit/2c1463.patch"
      sha256 "729c38c9f8c76580437d6ffe8bd91deaaebff9e4aa2684cfaf87edfa694fa4fc"
    end
    # Let environment find the slang header
    patch do
      url "https://github.com/davep/eg/commit/a22d276.patch"
      sha256 "262bea4186cabcedd154063bee08f86f4075545fd58c255ab3cfab8e09ff9d2a"
    end
    patch do
      url "https://github.com/davep/eg/commit/f724fd6.patch"
      sha256 "6b9d6bbd1575a4d3dfaa3b87bad833e349a7a1c1d4759d4866cda364b8ad3c43"
    end
  end

  depends_on "s-lang"

  def install
    inreplace "eglib.c", "/usr/share/", "#{HOMEBREW_PREFIX}/share/"
    system "make"
    bin.install "eg"
    man1.install "eg.1"
    # TODO: copy 'default-guide/eg.ng' to '#{HOMEBREW_PREFIX}/share/norton-guides/'
  end

  test do
    # It will return a non-zero exit code when called with any option
    # except a filename, but will return success even if the file
    # doesn't exist, and we're exploiting this here.
    ENV["TERM"] = "xterm"
    system "eg", "not_here.ng"
  end
end
