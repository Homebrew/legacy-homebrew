require 'formula'

class TwoBWm < Formula
  homepage 'https://github.com/venam/2bwm'
  version '2013-3'
  depends_on :x11
  url('https://github.com/venam/2bwm.git',
      :using => :git,
      :revision => '7cf7c48919afe5479a95be5355a29aee951ae4a4')

  def install
    system "make"
    bin.install '2bwm', 'hidden'
    man1.install '2bwm.man' => '2bwm.1', 'hidden.man' => 'hidden.1'
  end

  def patches
    # sets the modkey to 'option', better for apple keyboards
    # sets the terminal to urxvt
    DATA
  end

  def caveats; <<-EOS.undent
    MODKEY is 'option'
    EOS
  end

end

__END__
diff --git a/config.h b/config.h
index 758105e..776b18c 100644
--- a/config.h
+++ b/config.h
@@ -3 +3 @@
-#define MOD             XCB_MOD_MASK_4       /* Super/Windows key  or check xmodmap(1) with -pm*/
+#define MOD             XCB_MOD_MASK_1       /* Super/Windows key  or check xmodmap(1) with -pm*/
@@ -30 +30 @@ static const char *menucmd[] = { "/bin/my_menu.sh", NULL };
-static const char *terminal[] = { "urxvtc", NULL };
+static const char *terminal[] = { "urxvt", NULL };
