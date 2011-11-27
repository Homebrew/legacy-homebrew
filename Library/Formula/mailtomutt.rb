require 'formula'

class Mailtomutt < Formula
  url 'http://downloads.sourceforge.net/project/mailtomutt/MailtoMutt/v0.4.1/mailtomutt-0.4.1.tar.bz2'
  homepage 'http://mailtomutt.sourceforge.net'
  md5 'ce108e8574df129425d8156ff8b830bf'

  def options
    [
      ["--iterm", "build for iTerm or iTerm2 users"]
    ]
  end
  
  def patches
    if ARGV.include? "--iterm"
      # patches for iTerm
      DATA
    end
  end

  def install
    system "xcodebuild SYMROOT=build"
    prefix.install "build/Default/MailtoMutt.app"
  end

  def caveats; <<-EOS.undent
    MaitoMutt.app was installed in:
      #{prefix}

    To symlink into ~/Applications:
      brew linkapps
    EOS
  end
end

__END__
diff -u /Volumes/MailtoMutt 0.4.1/Source/Mutt.m ./Mutt.m
--- /Volumes/MailtoMutt 0.4.1/Source/Mutt.m 2004-05-30 18:25:20.000000000 -0500
+++ ./Mutt.m 2007-09-08 13:19:55.000000000 -0500
@@ -13,7 +13,7 @@
NSDebug(@"Opening mutt with file %@", path);

/* create the source to the script */
- NSString *source = [ NSString stringWithFormat:@"tell application \"Terminal\"\nactivate\ndo script \"mutt -H '%@' \"\nend tell", path ];
+ NSString *source = [ NSString stringWithFormat:@"tell application \"iTerm\"\ntell the current terminal\nactivate current session\nlaunch session \"Default Session\"\ntell the last session\nwrite text \"mutt -H '%@'; exit;\"\nend tell\nend tell\nend tell", path ];

/* create the NSAppleScript object with the source */
# warning NSAppleScript has a leak when initializing objects
