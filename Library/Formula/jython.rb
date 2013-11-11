require 'formula'

class Jython < Formula
  homepage 'http://www.jython.org'
  url 'http://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.5.3/jython-installer-2.5.3.jar'
  sha1 '6b6ac4354733b6d68d51acf2f3d5c823a10a4ce4'

  depends_on 'coreutils'

  devel do
    url 'http://search.maven.org/remotecontent?filepath=org/python/jython-installer/2.7-b1/jython-installer-2.7-b1.jar'
    version '2.7-b1'
    sha1 '385a52a8a3c5d941d61a7b2ed76e8a351b3658f2'
  end

  def install
    system "java", "-jar", cached_download, "-s", "-d", libexec
    bin.install_symlink libexec/'bin/jython'
  end

  def post_install
    patch_list = Patches.new(post_install_patches)
    Dir.chdir installed_prefix do
      patch_installed patch_list
    end
  end

 def patch_installed patch_list
    return if patch_list.empty?

    if patch_list.external_patches?
      ohai "Downloading patches"
      patch_list.download!
    end

    ohai "Patching in #{Pathname.pwd}"

    patch_list.each do |p|
      case p.compression
        when :gzip  then with_system_path { safe_system "gunzip",  p.compressed_filename }
        when :bzip2 then with_system_path { safe_system "bunzip2", p.compressed_filename }
      end
      # -f means don't prompt the user if there are errors; just exit with non-zero status
      safe_system '/usr/bin/patch', '-f', *(p.patch_args)
    end
  end

  def post_install_patches
    if build.devel?
      @@post_install_patches
    end
  end

  @@post_install_patches = 'https://gist.github.com/offbyone/6432986/raw/70fd9bbeee6e0108322e4711f9749fcf5d632343/jython2.7+homebrew+patch'

end
