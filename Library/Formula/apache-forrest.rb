class ApacheForrest < Formula
  desc "Publishing framework providing multiple output formats"
  homepage "https://forrest.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=forrest/apache-forrest-0.9-sources.tar.gz"
  sha256 "c6ac758db2eb0d4d91bd1733bbbc2dec4fdb33603895c464bcb47a34490fb64d"

  bottle do
    cellar :any_skip_relocation
    sha256 "615ab5a39fcc19a110ebab166c05a614149374e65c5f9a7a4522fa400b8d4118" => :el_capitan
    sha256 "cd0e4ceeb9e01118fe69bee3f80ccff63a951e01bf76c87146185ae6fe474c09" => :yosemite
    sha256 "a0e06c41204932f1427e38d47b3c4442dea7f7c3312f959faf1b725d35d85a52" => :mavericks
  end

  depends_on :java

  resource "deps" do
    url "https://www.apache.org/dyn/closer.cgi?path=forrest/apache-forrest-0.9-dependencies.tar.gz"
    sha256 "33146b4e64933691d3b779421b35da08062a704618518d561281d3b43917ccf1"
  end

  def install
    libexec.install Dir["*"]
    (bin/"forrest").write_env_script libexec/"bin/forrest", Language::Java.java_home_env

    resource("deps").stage do
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
        "tools/jetty",
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
