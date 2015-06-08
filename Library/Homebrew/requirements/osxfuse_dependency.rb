require "requirement"

class OsxfuseDependency < Requirement
  fatal true
  default_formula "osxfuse"
  cask "osxfuse"
  download "https://osxfuse"

  satisfy { Formula["osxfuse"].installed? || self.class.binary_osxfuse_installed? }

  def self.binary_osxfuse_installed?
    File.exist?("/usr/local/include/osxfuse/fuse.h") && !File.symlink?("/usr/local/include/osxfuse")
  end

  env do
    ENV.append_path "PKG_CONFIG_PATH", HOMEBREW_PREFIX/"Library/ENV/pkgconfig/fuse"
  end
end

class ConflictsWithBinaryOsxfuse < Requirement
  fatal true
  satisfy { HOMEBREW_PREFIX.to_s != "/usr/local" || !OsxfuseDependency.binary_osxfuse_installed? }

  def message
    <<-EOS.undent
      osxfuse is already installed from the binary distribution and
      conflicts with this formula.
    EOS
  end
end
