require 'formula'

class DrushMake <Formula
  url 'http://ftp.drupal.org/files/projects/drush_make-6.x-2.0-beta8.tar.gz'
  homepage 'http://drupal.org/project/drush_make'
  md5 '75c2d4b1ae7f69f843d641723f4aae5a'

  def patches
    DATA
  end
end

class Drush <Formula
  url 'http://ftp.drupal.org/files/projects/drush-6.x-3.3.tar.gz'
  homepage 'http://drupal.org/project/drush'
  version '3.3' # 3.3 is detected, but lets be explicit here
  md5 'ed7ee13415548c643358a8a870534a5e'

  def install
    prefix.install Dir['*'] # No lib folder, so this is OK for now.
    bin.mkpath
    symlink prefix+'drush', bin+'drush'
    DrushMake.new.brew { (prefix+'commands/drush_make').install Dir['*'] }
  end
end

__END__
diff --git a/drush_make.download.inc b/drush_make.download.inc
index 99ff080..4a98166 100644
--- a/drush_make.download.inc
+++ b/drush_make.download.inc
@@ -162,7 +162,7 @@ class DrushMakeDownload_Get extends DrushMakeDownload {
       // Detect whether the user uses --strip-path or --strip-components
       $strip_option = drush_get_option('strip-option', FALSE);
       if (!$strip_option) {
-        drush_shell_exec("man tar | grep strip-component");
+        drush_shell_exec("man -t tar | grep strip-component");
         $info = drush_shell_exec_output();
         if ($info) {
           $strip_option = 'component';
