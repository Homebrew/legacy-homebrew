require 'formula'

class Handbrakecli <Formula
   @@svnversion = '3606'
   @@arch = 'x86_64'
   @@dmgname = "HandBrake-svn#{@@svnversion}-MacOSX.5_CLI_#{@@arch}"

   url 'https://build.handbrake.fr/job/Mac/lastSuccessfulBuild/artifact/trunk/packages/'+@@dmgname+'.dmg', \
      :using => NoUnzipCurlDownloadStrategy
   version "#{@@svnversion}.#{/64/.match(@@arch) ? '64' : '32'}"
   homepage 'http://handbrake.fr/'
   md5 ''

   # don't strip binaries
   skip_clean ['bin']

   def install
      system "hdiutil attach #{@@dmgname}.dmg"
      bin.mkdir
      cp "/Volumes/#{@@dmgname}/HandBrakeCLI", (bin+'HandBrakeCLI')
      chmod 0555, (bin+'HandBrakeCLI')
      system "hdiutil detach /Volumes/#{@@dmgname}"
   end
end
