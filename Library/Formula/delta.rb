require "formula"

# Two requests are needed to download from Tigris.org. In the first, the server
# provides a cookie and then redirects the client to a servlet. The servlet
# requires this cookie, or it will send the client in a redirect loop.
#
# The Homebrew CurlDownloadStrategy does not store cookies, so this subclass
# adds the -c flag and a temporary cookie storage file.
#
# This relies on internal details of the CurlDownloadStrategy, so expect it to
# break.
class CurlWithCookiesDownloadStrategy < CurlDownloadStrategy
  def cookie_path
    @cookie_path ||= Pathname.new("#{self.tarball_path}.cookies")
  end

  def _fetch
    curl @url, "-c", cookie_path, "-C", self.downloaded_size, "-o",
      self.temporary_path
  end
end


# Another hack. Tigris.org"s Subversion server requires public checkouts to be
# done with the username "guest", but apparently we cannot just use guest@ in
# the URL to accomplish this.
#
# Since SubversionDownloadStrategy calls quiet_safe_system with the svn command
# to execute, we can tack our arguments on here. Terrible, right?
class GuestSubversionDownloadStrategy < SubversionDownloadStrategy
  def quiet_safe_system *args
    super *args + ["--username", "guest"]
  end
end


class Delta < Formula
  homepage "http://delta.tigris.org/"
  url "http://delta.tigris.org/files/documents/3103/33566/delta-2006.08.03.tar.gz",
    :using => CurlWithCookiesDownloadStrategy
  sha1 "e5ab4933bdbcddac3ba96d6ec497213b42f9f26e"

  head "http://delta.tigris.org/svn/delta/trunk",
    :using => GuestSubversionDownloadStrategy

  def install
    system "make"
    bin.install("delta")
    bin.install("multidelta")
    bin.install("topformflat")
  end
end
