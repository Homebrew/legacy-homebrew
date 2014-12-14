require "formula"

class Nimble < Formula
  homepage "https://github.com/nim-lang/nimble"

  stable do
    url "https://github.com/nim-lang/nimble/archive/v0.4.tar.gz"
    sha1 "54a1787b220e849229f53c7ae42244426d05b0b8"
  end

  head "https://github.com/nimrod-code/nimble.git"

  depends_on "nimrod"

  resource "nimble-wrapper" do
    url "https://github.com/philip-wernersbach/nimble-wrapper.git"
  end

  # This patch fixes symlinking issues when there's a space in a path.
  # See https://github.com/nim-lang/nimble/pull/73
  patch :DATA unless build.head?

  def install
    (prefix/"nimble_wrapper").install buildpath => "nimble"
    mkdir buildpath

    resource("nimble-wrapper").stage do
      system "nimrod", "c", "-r", "install", prefix/"nimble_wrapper"
    end

    if build.stable?
      bin.install_symlink prefix/"nimble_wrapper/bin/babel"
      bin.install_symlink prefix/"nimble_wrapper/bin/babel" => "nimble"
    else
      bin.install_symlink prefix/"nimble_wrapper/bin/nimble"
    end
  end

  test do
    # BrewTestBot installs to a directory with a space in it. We create a
    # directory with a space in it to test nimble's behavior when there's a
    # space in the install path.
    mkdir "Path Space Test"
    ENV["HOME"] = Pathname.pwd/"Path Space Test"

    # Test nimble by installing the IRC package. The IRC package was chosen
    # because it's an official package and it doesn't rely on compiler
    # internals.
    system "#{bin}/nimble", "install", "-y", "irc"
  end
end

__END__
--- a/src/babel.nim
+++ b/src/babel.nim
@@ -511,7 +511,7 @@ proc installFromDir(dir: string, latest: bool, options: TOptions,
         # some other package's binary!
         if existsFile(binDir / bin): removeFile(binDir / cleanBin)
         echo("Creating symlink: ", pkgDestDir / bin, " -> ", binDir / cleanBin)
-        doCmd("ln -s \"" & pkgDestDir / bin & "\" " & binDir / cleanBin)
+        createSymlink(pkgDestDir / bin, binDir / cleanBin)
       elif defined(windows):
         let dest = binDir / cleanBin.changeFileExt("bat")
         echo("Creating stub: ", pkgDestDir / bin, " -> ", dest)
