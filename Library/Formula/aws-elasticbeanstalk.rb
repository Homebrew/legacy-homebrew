require 'formula'

class AwsElasticbeanstalk < AmazonWebServicesFormula
  homepage 'http://aws.amazon.com/code/AWS-Elastic-Beanstalk/6752709412171743'
  url 'https://s3.amazonaws.com/elasticbeanstalk/cli/AWS-ElasticBeanstalk-CLI-2.4.0.zip'
  sha1 'dedd4bbdd037c52ab417f80170f3109319f0dce2'

  def install
    # Remove versions for other platforms.
    rm_rf Dir['eb/windows']
    rm_rf Dir['eb/linux']
    rm_rf Dir['AWSDevTools/Windows']
    rm_rf Dir['api/bin/*.cmd']

    libexec.install %w{AWSDevTools api eb}
    bin.install_symlink libexec/"eb/macosx/python2.7/eb"
    bin.install_symlink Dir[libexec/'api/bin/*']
  end

  def patches
      # fixes problems with relative paths and symlinks
      DATA
  end
end

__END__

diff --git a/api/bin/setup.rb b/api/bin/setup.rb
index 39c8895..ebc67d8 100644
--- a/api/bin/setup.rb
+++ b/api/bin/setup.rb
@@ -13,11 +13,31 @@
 # ANY KIND, either express or implied. See the License for the specific
 # language governing permissions and limitations under the License.
 #
-$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
+require 'pathname'
+
+this_file = Pathname.new(__FILE__).realpath
+this_directory = File.dirname(this_file)
+
+$:.unshift(
+  File.absolute_path(
+    File.join(
+      this_directory,
+      '..',
+      'lib'
+    )
+  )
+)
 
 require 'aws/elasticbeanstalk'
 
-ca_bundle_file = File.join(File.dirname(__FILE__), '..', 'ca-bundle.crt')
+ca_bundle_file = File.absolute_path(
+  File.join(
+    this_directory,
+    '..',
+    'ca-bundle.crt'
+  )
+)
+
 abort "CA Bundle required" unless File.exists?(ca_bundle_file)
 
 config = {


