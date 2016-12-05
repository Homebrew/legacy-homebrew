class FseventsTools < Formula
  desc "inotify-tools for OS X's FSEvents"
  homepage "http://geoff.greer.fm/fsevents/"
  url "http://geoff.greer.fm/fsevents/releases/fsevents-tools-1.0.0.tar.gz"
  sha256 "498528e1794fa2b0cf920bd96abaf7ced15df31c104d1a3650e06fa3f95ec628"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Make sure notifywait exits when test-file is created.
    system "bash", "-c", "(sleep 5.0; touch test-file;) &"
    system "#{bin}/notifywait", "."
    rm "test-file"
  end
end
