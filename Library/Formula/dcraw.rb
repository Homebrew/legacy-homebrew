require "formula"

class DcrawDownloadStrategy < VCSDownloadStrategy
  def initialize name, resource
    super
    @revision = resource.version.to_s.split[1]
  end

  def fetch
    manpage_url = "http://www.cybercom.net/~dcoffin/dcraw/dcraw.1"

    @clone.mkdir unless @clone.exist?
    @clone.cd do
      ohai "Downloading #{@url}"
      curl "-odcraw.c,v", @url
      ohai "Downloading #{manpage_url}"
      curl "-odcraw.1", manpage_url
      safe_system "co -p#{@revision} dcraw.c > dcraw.c.#{@revision}"
    end
  end

  def stage
    FileUtils.cp @clone.join("dcraw.c.#{@revision}"), Pathname.pwd.join("dcraw.c")
    FileUtils.cp @clone.join("dcraw.1"), Dir.pwd
  end

  def cache_tag
    "dcraw"
  end

  def cached_location
    @clone.join("dcraw.c.#{@revision}")
  end
end

class Dcraw < Formula
  homepage "http://www.cybercom.net/~dcoffin/dcraw/"

  # DCraw uses RCS (https://www.gnu.org/software/rcs/) to manage revisions,
  # and does not provide builds or snapshots.
  # Versioned tarballs on the website are not useful to Homebrew, since
  # the author changes them from time to time, instead of creating new
  # versions.
  # This is the URL for the RCS history file.
  url "http://www.cybercom.net/~dcoffin/dcraw/RCS/dcraw.c,v", using: DcrawDownloadStrategy

  # Hash of the resulting .c file, not the history file above.
  sha1 "ba96983ec8be21f4ede69a4ec4f5c7d5458d394b"

  # First part is the program version, second part is the RCS revision.
  version "9.22-1.467"

  depends_on "jpeg"
  depends_on "jasper"
  depends_on "little-cms2"

  def install
    ENV.append_to_cflags "-I#{HOMEBREW_PREFIX}/include -L#{HOMEBREW_PREFIX}/lib"
    system "#{ENV.cc} -o dcraw #{ENV.cflags} dcraw.c -lm -ljpeg -llcms2 -ljasper"
    bin.install "dcraw"
    man1.install "dcraw.1"
  end
end
