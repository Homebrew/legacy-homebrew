# Speed up head clone, see: https://developer.mozilla.org/en-US/docs/Developer_Guide/Source_Code/Mercurial/Bundles
class HgBundleDownloadStrategy < CurlDownloadStrategy
  def stage
    mkdir "mozilla-central"
    quiet_safe_system hgpath, "init", "mozilla-central"
    chdir
    quiet_safe_system hgpath, "unbundle", cached_location
    quiet_safe_system hgpath, "pull", "--update", meta.fetch(:repo)
  end
end

class Python273Requirement < Requirement
  fatal true
  default_formula "python"

  satisfy do
    `python -V 2>&1` =~ /^Python 2.7.(\d+)/
    $1.to_i >= 3
  end
end

class Xulrunner < Formula
  desc "Mozilla runtime package to bootstrap XUL+XPCOM applications"
  homepage "https://developer.mozilla.org/docs/XULRunner"

  stable do
    # Always use direct URLs (releases/<version>/) instead of releases/latest/
    url "https://archive.mozilla.org/pub/mozilla.org/xulrunner/releases/33.0/source/xulrunner-33.0.source.tar.bz2"
    sha256 "99402cf84949e06bac72d8abbdecde57e8af465727001ed6849a34632f20bcdb"

    # https://github.com/Homebrew/homebrew/issues/33558
    depends_on MaximumMacOSRequirement => :mavericks
  end

  bottle do
    cellar :any
    sha1 "222b1eaabea7a2aaa4712682c9580ed70f78ceb8" => :mavericks
    sha1 "3eb54b046978536c2161a3961e0e50a624223a0d" => :mountain_lion
  end

  head do
    url "https://archive.mozilla.org/pub/mozilla.org/firefox/bundles/mozilla-central.hg",
      :using => HgBundleDownloadStrategy, :repo => "https://hg.mozilla.org/mozilla-central"

    depends_on :hg => :build
    depends_on "gettext" => :build
  end

  depends_on :macos => :lion # needs clang++
  depends_on :xcode => :build
  depends_on :python => :build
  depends_on Python273Requirement => :build
  depends_on "gnu-tar" => :build
  depends_on "pkg-config" => :build
  depends_on "yasm"
  depends_on "nss"
  depends_on "nspr"

  fails_with :gcc do
    cause "Mozilla XULRunner only supports Clang on OS X"
  end

  fails_with :llvm do
    cause "Mozilla XULRunner only supports Clang on OS X"
  end

  resource "autoconf213" do
    url "http://ftpmirror.gnu.org/autoconf/autoconf-2.13.tar.gz"
    mirror "https://ftp.gnu.org/gnu/autoconf/autoconf-2.13.tar.gz"
    sha256 "f0611136bee505811e9ca11ca7ac188ef5323a8e2ef19cffd3edb3cf08fd791e"
  end

  def install
    if build.head?
      resource("autoconf213").stage do
        system "./configure", "--disable-debug", "--program-suffix=213", "--prefix=#{buildpath}/ac213"
        system "make", "install"
      end
      ENV["AUTOCONF"] = buildpath/"ac213/bin/autoconf213"
    end

    # build xulrunner to objdir and disable tests, updater.app and crashreporter.app, specify sdk path
    (buildpath/"mozconfig").write <<-EOS.undent
      . $topsrcdir/xulrunner/config/mozconfig
      mk_add_options MOZ_OBJDIR=objdir
      ac_add_options --disable-tests
      ac_add_options --disable-updater
      ac_add_options --disable-crashreporter
      ac_add_options --with-macos-sdk=#{MacOS.sdk_path}
      ac_add_options --with-nss-prefix=#{Formula["nss"].opt_prefix}
      ac_add_options --with-nspr-prefix=#{Formula["nspr"].opt_prefix}
    EOS
    # fixed usage of bsdtar with unsupported parameters (replaced with gnu-tar)
    inreplace "toolkit/mozapps/installer/packager.mk", "$(TAR) -c --owner=0 --group=0 --numeric-owner",
              "#{Formula["gnu-tar"].opt_bin}/gtar -c --owner=0 --group=0 --numeric-owner"

    system "make", "-f", "client.mk", "build"
    system "make", "-f", "client.mk", "package"

    frameworks.mkpath
    if build.head?
      # update HEAD version here with every version bump
      tar_path = "objdir/dist/xulrunner-33.0a1.en-US.mac64.tar.bz2"
    else
      tar_path = "objdir/dist/xulrunner-#{version.to_s[/\d+\.\d+(\.\d+)?/]}.en-US.mac64.tar.bz2"
    end
    system "tar", "-xvj", "-C", frameworks, "-f", tar_path

    # symlink only xulrunner here will fail (assumes dylibs in same directory)
    bin.write_exec_script frameworks/"XUL.framework/Versions/Current/xulrunner"

    # fix Trace/BPT trap: 5 error on OS X 10.9, see laurentj/slimerjs#135
    # and https://bugzilla.mozilla.org/show_bug.cgi?id=922590#c4
    if MacOS.version >= :mavericks
      (frameworks/"XUL.framework/Versions/Current/Info.plist").write <<-EOS.undent
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <dict>
          <key>CFBundleIdentifier</key>
          <string>org.mozilla.xulrunner</string>
        </dict>
        </plist>
      EOS
    end
  end

  test do
    system "#{bin}/xulrunner", "-v"
  end
end
