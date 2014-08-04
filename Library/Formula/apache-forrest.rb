require 'formula'

class ApacheForrest < Formula
  homepage 'http://forrest.apache.org/'
  url 'http://www.apache.org/dyn/closer.cgi?path=forrest/apache-forrest-0.9-sources.tar.gz'
  sha1 '8c7b49a7dff4b3f60a52c7696684168b6d454a47'

  resource 'deps' do
    url 'http://www.apache.org/dyn/closer.cgi?path=forrest/apache-forrest-0.9-dependencies.tar.gz'
    sha1 '10a4442d46baeadd3ba3377ed29ed694c86ece25'
  end

  # Prevent deletion of intentionally-empty subdirs inside of
  # template directories:
  skip_clean "libexec/main/template-sites",
    "libexec/main/fresh-site",
    "libexec/plugins/pluginTemplate"

  def install
    libexec.install Dir['*']
    bin.install_symlink "#{libexec}/bin/forrest"

    resource('deps').stage do
      # To avoid conflicts with directory names already installed from the
      # main tarball, surgically install contents of dependency tarball
      deps_to_install = [
        "lib",
        "main/webapp/resources/schema/relaxng",
        "main/webapp/resources/stylesheets",
        "plugins/org.apache.forrest.plugin.output.pdf/",
        "tools/ant",
        "tools/forrestbot/lib",
        "tools/forrestbot/webapp/lib",
        "tools/jetty"
      ]
      deps_to_install.each do |dep|
        (libexec+dep).install Dir["#{dep}/*"]
      end
    end
  end

  test do
    system "#{bin}/forrest", "-projecthelp"
  end
end
